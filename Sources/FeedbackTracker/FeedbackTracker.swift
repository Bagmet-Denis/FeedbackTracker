// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import MessageUI

public extension View {
    func addFeedback(isPresented: Binding<Bool>, language: Language, urlServer: String) -> some View{
        modifier(FeedbackModifier(isPresented: isPresented, language: language, urlServer: urlServer))
            .preferredColorScheme(.light)
    }
}

struct FeedbackModifier: ViewModifier {
    @StateObject var feedbackRepository = FeedbackRepository()
    @Binding var isPresented: Bool
    let language: Language
    let urlServer: String
    
    @State var showAlert: Bool = false
    
    func body(content: Content) -> some View {
        ZStack{
            content
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
                        
                        .cancel(Text(Localization.text(.cancel, language: language)))
                    ])
                }
            
            
            if showAlert{
                FeedbackAlertView(
                    isPresented: $showAlert,
                    emailPlaceholder: Localization.text(.email, language: language),
                    email: $feedbackRepository.email,
                    messagePlaceholder: Localization.text(.message, language: language),
                    message: $feedbackRepository.message,
                    title: Localization.text(.feedback, language: language)
                ){
                    Task{
                        await feedbackRepository.sendFeedback(urlPath: urlServer)
                    }
                    
                    showAlert = false
                }
            }
        }
    }
    
    func openMail() {
        if let url = URL(string: "mailto:info@appbox.pw"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct FeedbackAlertView: View {
    @Binding var isPresented: Bool
    
    var emailPlaceholder: String = ""
    @Binding var email: String
    
    var messagePlaceholder: String = ""
    @Binding var message: String
    
    let title: String
    
    var action: ()->Void
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                    
                    Divider()
                    
                    TextField(emailPlaceholder, text: $email)
                        .disableAutocorrection(true)
                        .textFieldStyle(.plain)
                        .frame(height: 40)
                        .padding(.horizontal, 9)
                        .background(Color.white)
                    
                    Divider()
                    
                    CustomFeedbackTextEditor(placeholder: messagePlaceholder, text: $message)
                    
                    Divider()
                    
                    HStack{
                        Button {
                            isPresented = false
                        } label: {
                            HStack{
                                Spacer(minLength: 0)
                                
                                Text("Отмена")
                                
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
                                
                                Text("Отправить")
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 15)
                            .contentShape(Rectangle())
                        }
                          .disabled(!message.isEmpty ? false : true)
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
