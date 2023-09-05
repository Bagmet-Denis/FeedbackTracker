// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import MessageUI

public extension View {
    func addFeedback(isPresented: Binding<Bool>, language: Language, emailSupport: String, urlServer: String) -> some View{
        modifier(FeedbackModifier(isPresented: isPresented, language: language, emailSupport: emailSupport, urlServer: urlServer))
            .preferredColorScheme(.light)
    }
}

struct FeedbackModifier: ViewModifier {
    @StateObject var feedbackRepository = FeedbackRepository()
    @Binding var isPresented: Bool
    let language: Language
    let emailSupport: String
    let urlServer: String
    
    @State var showAlert: Bool = false
    @State var showToastSuccessfulCopy: Bool = false
    
    func body(content: Content) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
            content
            
            VStack{
                Spacer()
                
                Color.clear
                    .frame(height: 1)
                    .actionSheet(isPresented: $isPresented) {
                        ActionSheet(title: Text(Localization.text(.titleSheet, language: language)), buttons: [
                            .default(Text(Localization.text(.quickFeedback, language: language)), action: {
                                feedbackRepository.email.removeAll()
                                feedbackRepository.message.removeAll()
                                showAlert = true
                            }),
                            .default(Text(Localization.text(.sendToEmail, language: language)), action: {
                                openMail()
                            }),
                            .default(Text(Localization.text(.copyEmail, language: language)), action: {
                                UIPasteboard.general.string = emailSupport
                                showToastSuccessfulCopy = true
                            }),
                            .cancel(Text(Localization.text(.cancel, language: language)))
                        ])
                    }
            }
            
            if showAlert{
                FeedbackAlertView(
                    isPresented: $showAlert,
                    email: $feedbackRepository.email,
                    message: $feedbackRepository.message,
                    emailPlaceholder: Localization.text(.email, language: language),
                    messagePlaceholder: Localization.text(.message, language: language),
                    title: Localization.text(.feedback, language: language),
                    action: {
                        Task{await feedbackRepository.sendFeedback(urlPath: urlServer)}
                    },
                    language: language)
            }
            
            CustomToastSuccessfullyCopied(language: language)
//                .offset(y: showToastSuccessfulCopy ? 10 : -UIScreen.main.bounds.height)
//                .opacity(showToastSuccessfulCopy ? 1 : 0)
//                .animation(.easeInOut(duration: 1), value: showToastSuccessfulCopy)
                .onChange(of: showToastSuccessfulCopy) { _ in
                    if showToastSuccessfulCopy{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            showToastSuccessfulCopy = false
                        }
                    }
                }
        }
    }
    
    func openMail() {
        if let url = URL(string: emailSupport),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct FeedbackAlertView: View {
    @Binding var isPresented: Bool
    @Binding var email: String
    @Binding var message: String
    
    var emailPlaceholder: String = ""
    var messagePlaceholder: String = ""
    
    
    let title: String
    var action: ()->Void
    
    let language: Language

    var body: some View {
        ZStack {
            if isPresented {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack{
                        
                        Spacer()
                        
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(Localization.text(.emailTitle, language: language))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    TextField(emailPlaceholder, text: $email)
                        .disableAutocorrection(true)
                        .textFieldStyle(.plain)
                        .frame(height: 40)
                        .padding(.horizontal, 9)
                        .background(Color.white)
                    
                    Divider()
                    
                    Text(Localization.text(.messageTitle, language: language))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    CustomFeedbackTextEditor(placeholder: messagePlaceholder, text: $message)
                    
                    Divider()
                    
                    HStack{
                        Button {
                            isPresented = false
                        } label: {
                            HStack{
                                Spacer(minLength: 0)
                                
                                Text(Localization.text(.cancel, language: language))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 15)
                            .contentShape(Rectangle())
                        }
                        
                        Divider()
                            .frame(height: 50)
                        
                        Button {
                            action()
                        } label: {
                            HStack{
                                Spacer(minLength: 0)
                                
                                Text(Localization.text(.submit, language: language))
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 15)
                            .contentShape(Rectangle())
                        }
                        .disabled(message.isEmpty)
                        //                          .disabled(!message.isEmpty ? false : true)
                        // .disabled(email.contains("@") && !message.isEmpty ? false : true)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 1.4)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
            }
        }
    }
}

struct CustomFeedbackTextEditor: View {
    var placeholder: String = "Denis"
    @Binding var text: String
    
    let internalPadding: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            
            TextEditor(text: $text)
                .padding(internalPadding)
                .frame(height: UIScreen.main.bounds.height / 7)
                .background(Color.white)
                .cornerRadius(5)
                .opacity(text.isEmpty ? 0.1 : 1)
            
        }
        .background(Color.white)
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct CustomToastSuccessfullyCopied: View{
    let language: Language
    var body: some View{
        Text(Localization.text(.successfulCopied, language: language))
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}
