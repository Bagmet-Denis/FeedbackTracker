// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public extension View {
    func addFeedback(isPresented: Binding<Bool>, language: Language, colorTheme: ColorTheme, shouldAdjustForKeyboard: Bool, emailSupport: String, urlServer: String) -> some View{
        modifier(FeedbackModifier(
            isPresented: isPresented,
            language: language,
            theme: colorTheme,
            shouldAdjustForKeyboard: shouldAdjustForKeyboard,
            emailSupport: emailSupport,
            urlServer: urlServer
        ))
    }
}

struct FeedbackModifier: ViewModifier {
    @StateObject var feedbackRepository = FeedbackRepository()
    @Binding var isPresented: Bool
    let language: Language
    let theme: ColorTheme
    let shouldAdjustForKeyboard: Bool
    let emailSupport: String
    let urlServer: String
    
    @State var isPresentedSheetSendMessage: Bool = false
    @State var showToastSuccessfulCopy: Bool = false
    @State var showToastSuccessfulSendReport: Bool = false
    
    func body(content: Content) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
            content
                .sheet(isPresented: $isPresentedSheetSendMessage) {
                    NavigationView {
                        VStack {
                            Text(Localization.text(.emailTitle, language: language))
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                            
                            TextField(Localization.text(.email, language: language), text: $feedbackRepository.email)
                                .disableAutocorrection(true)
                                .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                                .textFieldStyle(.plain)
                                .frame(height: 40)
                            
                            Text(Localization.text(.messageTitle, language: language))
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .padding(10)
                            
                            CustomFeedbackTextEditor(placeholder: Localization.text(.message, language: language), text: $feedbackRepository.message, theme: theme)
                        }
                        .padding()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(Text(Localization.text(.feedback, language: language)))
                        
                    }
                    .navigationViewStyle(.stack)
                }
                .actionSheet(isPresented: $isPresented) {
                    ActionSheet(title: Text(Localization.text(.titleSheet, language: language)), buttons: [
                        .default(Text(Localization.text(.quickFeedback, language: language)), action: {
                            feedbackRepository.email.removeAll()
                            feedbackRepository.message.removeAll()
                            isPresentedSheetSendMessage = true
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
            
            
            
//            if showAlert{
//                FeedbackAlertView(
//                    isPresented: $showAlert,
//                    email: $feedbackRepository.email,
//                    message: $feedbackRepository.message,
//                    emailPlaceholder: Localization.text(.email, language: language),
//                    messagePlaceholder: Localization.text(.message, language: language),
//                    title: Localization.text(.feedback, language: language),
//                    action: {
//                        Task{await feedbackRepository.sendFeedback(urlPath: urlServer)}
//                        
//                        showAlert = false
//                        showToastSuccessfulSendReport = true
//                    },
//                    theme: theme,
//                    language: language,
//                    shouldAdjustForKeyboard: shouldAdjustForKeyboard
//                )
//            }
            
//            CustomToastSuccessfullySendReport(language: language, theme: theme)
//                .offset(y: showToastSuccessfulSendReport ? 10 : -UIScreen.main.bounds.height * 2)
//                .opacity(showToastSuccessfulSendReport ? 1 : 0)
//                .animation(.easeInOut(duration: 0.8), value: showToastSuccessfulSendReport)
//                .onChange(of: showToastSuccessfulSendReport) { _ in
//                    if showToastSuccessfulSendReport{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                            showToastSuccessfulSendReport = false
//                        }
//                    }
//                }
//            
//            CustomToastSuccessfullyCopied(language: language, theme: theme)
//                .offset(y: showToastSuccessfulCopy ? 10 : -UIScreen.main.bounds.height * 2)
//                .opacity(showToastSuccessfulCopy ? 1 : 0)
//                .animation(.easeInOut(duration: 0.8), value: showToastSuccessfulCopy)
//                .onChange(of: showToastSuccessfulCopy) { _ in
//                    if showToastSuccessfulCopy{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                            showToastSuccessfulCopy = false
//                        }
//                    }
//                }
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
    
    let theme: ColorTheme
    let language: Language
    let shouldAdjustForKeyboard: Bool // Новый параметр
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var alertViewHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(theme == .light ? Color.black : Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .opacity(0.8)
                    
                    Divider()
                    
                    Text(Localization.text(.emailTitle, language: language))
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    TextField(emailPlaceholder, text: $email)
                        .disableAutocorrection(true)
                        .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                        .textFieldStyle(.plain)
                        .frame(height: 40)
                        .padding(.horizontal, 9)
                    
                    Divider()
                    
                    Text(Localization.text(.messageTitle, language: language))
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    CustomFeedbackTextEditor(placeholder: messagePlaceholder, text: $message, theme: theme)
                    
                    Divider()
                    
                    HStack{
                        Button {
                            isPresented = false
                        } label: {
                            Text(Localization.text(.cancel, language: language))
                                .padding(.vertical, 14)
                                .contentShape(.rect)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        Divider()
                            .frame(height: 50)
                        
                        Button {
                            action()
                        } label: {
                            Text(Localization.text(.submit, language: language))
                                .padding(.vertical, 14)
                                .contentShape(.rect)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(message.isEmpty)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 1.4)
                .background(theme == .light ? Color(hex: "F0F1F1") : Color(hex: "272727"))
                .cornerRadius(16)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                alertViewHeight = geometry.size.height
                            }
                    }
                )
                .offset(y: shouldAdjustForKeyboard ? -keyboardHeight / 3 : 0)
                .animation(.easeOut(duration: 0.16), value: keyboardHeight)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                        keyboardHeight = keyboardFrame.height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                }
                
                ButtonHideKeyboard()
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            keyboardHeight = keyboardFrame.height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

struct CustomFeedbackTextEditor: View {
    var placeholder: String = "Denis"
    @Binding var text: String
    
    let theme: ColorTheme
    let internalPadding: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            
            if #available(iOS 16.0, *) {
                TextEditor(text: $text)
                    .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                    .padding(internalPadding)
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(5)
                    .opacity(text.isEmpty ? 0.1 : 1)
            } else {
                TextEditor(text: $text)
                    .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                    .padding(internalPadding)
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .cornerRadius(5)
                    .opacity(text.isEmpty ? 0.1 : 1)
            }
            
        }
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

#Preview{
    FeedbackAlertView(isPresented: .constant(true), email: .constant("Test"), message: .constant("Test"), emailPlaceholder: "Test", messagePlaceholder: "Test", title: "Test", action: {
        
    }, theme: .dark, language: .en, shouldAdjustForKeyboard: true)
    .preferredColorScheme(.dark)
    
    CustomToastSuccessfullyCopied(language: .en, theme: .light)
}

struct CustomToastSuccessfullyCopied: View{
    let language: Language
    let theme: ColorTheme
    var body: some View{
        Text(Localization.text(.successfulCopied, language: language))
            .padding()
            .foregroundColor(theme == .light ? Color.black : Color.white)
            .background(theme == .light ? Color.white : Color(hex: "272727"))
            .clipShape(Capsule())
            .shadow(radius: theme == .light ? 5 : 0)
    }
}

struct CustomToastSuccessfullySendReport: View{
    let language: Language
    let theme: ColorTheme
    var body: some View{
        Text(Localization.text(.successfulSendReport, language: language))
            .padding()
            .foregroundColor(theme == .light ? Color.black : Color.white)
            .background(theme == .light ? Color.white : Color(hex: "272727"))
            .clipShape(Capsule())
            .shadow(radius: theme == .light ? 5 : 0)
    }
}
