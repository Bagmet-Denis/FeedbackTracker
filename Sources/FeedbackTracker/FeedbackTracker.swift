// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import MessageUI

public extension View{
    func feedbackAlert(isPresented: Binding<Bool>, language: Language) -> some View{
        TextFieldWrapper(isPresented: isPresented, language: language, presentingView: self) {
            TextFieldAlert(title: "test")
        }
    }
}

public extension View {
    func addFeedback(isPresented: Binding<Bool>, language: Language) -> some View{
        modifier(FeedbackModifier(isPresented: isPresented, language: language))
    }
}

struct FeedbackModifier: ViewModifier {
    @Binding var isPresented: Bool
    let language: Language
    
    @State var showAlert: Bool = false
    
    func body(content: Content) -> some View {
        content
            .feedbackAlert(isPresented: $showAlert, language: language)
            .actionSheet(isPresented: $isPresented) {
                ActionSheet(title: Text(Localization.text(.titleSheet, language: language)), buttons: [
                    .default(Text(Localization.text(.quickFeedback, language: language)), action: {
                        showAlert = true
                    }),
                    .default(Text(Localization.text(.sendToEmail, language: language)), action: {
                        sendEmail()
                    }),
                    .cancel(Text(Localization.text(.cancel, language: language)))
                ])
            }
    }
    
    func sendEmail() {
        let recipient = "info@appbox.pw"
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject("Feedback")
        mailComposer.setMessageBody("", isHTML: false)
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        viewController.present(mailComposer, animated: true)
    }
}
