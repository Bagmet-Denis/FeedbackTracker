// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import MessageUI

public extension View{
    func feedbackAlert(isPresented: Binding<Bool>) -> some View{
        TextFieldWrapper(isPresented: isPresented, presentingView: self) {
            TextFieldAlert(title: "test")
        }
    }
}

public extension View {
    
    func addFeedback(isPresented: Binding<Bool>) -> some View {
        self.actionSheet(isPresented: isPresented) {
            ActionSheet(title: Text("Feedback"), buttons: [
                .default(Text("Quick Feedback"), action: {
                    textFieldAlert(title: "", textFields: [], actions: [], isPresented: isPresented)
                }),
                .default(Text("Send to Email"), action: {
                    sendEmail()
                }),
                .cancel()
            ])
        }
    }
    
    func sendEmail() {
        let recipient = "info@appbox.pw"
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject("Привет!")
        mailComposer.setMessageBody("Привет, как дела?", isHTML: false)
        
        guard MFMailComposeViewController.canSendMail() else {
            print("Не удалось отправить письмо.")
            return
        }
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        viewController.present(mailComposer, animated: true)
    }
}

public extension View {
    func customAlertView(isAlertVisible: Binding<Bool>) -> some View {
        CustomAlertView(isShowSheet: isAlertVisible)
    }
}

struct CustomAlertView: View {
    @Binding var isShowSheet: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        EmptyView()
            .feedbackAlert(isPresented: $showAlert)
            .actionSheet(isPresented: $isShowSheet) {
                ActionSheet(title: Text("Feedback"), buttons: [
                    .default(Text("Quick Feedback"), action: {
                        showAlert = true
                    }),
                    .default(Text("Send to Email"), action: {
                        sendEmail()
                    }),
                    .cancel()
                ])
            }
    }
    
    func sendEmail() {
        let recipient = "info@appbox.pw"
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject("Привет!")
        mailComposer.setMessageBody("Привет, как дела?", isHTML: false)
        
        guard MFMailComposeViewController.canSendMail() else {
            print("Не удалось отправить письмо.")
            return
        }
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        viewController.present(mailComposer, animated: true)
    }
}


public extension View {
    func content<Content: View>(@ViewBuilder content: () -> Content, showSheet: Binding<Bool>) -> some View {
        self.modifier(ContentModifier(showSheet: showSheet))
    }
}

struct ContentModifier: ViewModifier {
    @Binding var showSheet: Bool
    @State var showAlert: Bool = false
    
    func body(content: Content) -> some View {
        content
            .feedbackAlert(isPresented: $showAlert)
            .actionSheet(isPresented: $showSheet) {
                ActionSheet(title: Text("Feedback"), buttons: [
                    .default(Text("Quick Feedback"), action: {
                        showAlert = true
                    }),
                    .default(Text("Send to Email"), action: {
//                        sendEmail()
                    }),
                    .cancel()
                ])
            }
    }
}
