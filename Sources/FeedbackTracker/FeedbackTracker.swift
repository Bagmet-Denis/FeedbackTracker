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
        content
            .sheet(isPresented: $isPresentedSheetSendMessage) {
                FeedbackSheetSendMessage(
                    feedbackRepository: feedbackRepository,
                    language: language,
                    theme: theme,
                    urlServer: urlServer
                )
                .modifier(ViewModifierFeedbackSheetSendMessagePresentationDetents())
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
                        GlobalToastManager.shared.showToast(language: language, theme: theme) {
                            CustomToastSuccessfullyCopied(language: language, theme: theme)
                        }
                    }),
                    .cancel(Text(Localization.text(.cancel, language: language)))
                ])
            }
    }
    
    func openMail() {
        if let url = URL(string: emailSupport), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct ViewModifierFeedbackSheetSendMessagePresentationDetents: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDetents([.medium])
        } else {
            content
        }
    }
}

struct FeedbackSheetSendMessage: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var feedbackRepository: FeedbackRepository
    let language: Language
    let theme: ColorTheme
    let urlServer: String
    var body: some View {
        NavigationView {
            ZStack {
                if theme == .dark {
                    Color(hex: "#121212").ignoresSafeArea()
                } else {
                    Color(hex: "#F0F0F0").ignoresSafeArea()
                }
                
                ScrollView(showsIndicators: false, content: {
                    VStack(alignment: .leading) {
                        Text(Localization.text(.emailTitle, language: language))
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                        
                        TextField(Localization.text(.email, language: language), text: $feedbackRepository.email)
                            .disableAutocorrection(true)
                            .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(.rect(cornerRadius: 24))
                        
                        Text(Localization.text(.messageTitle, language: language))
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .padding(.top)
                        
                        CustomFeedbackTextEditor(placeholder: Localization.text(.message, language: language), text: $feedbackRepository.message, theme: theme)
                    }
                    .padding()
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(Localization.text(.feedback, language: language)))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        Task {
                            await feedbackRepository.sendFeedback(urlPath: urlServer)
                            GlobalToastManager.shared.showToast(language: language, theme: theme) {
                                CustomToastSuccessfullySendReport(language: language, theme: theme)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
        .preferredColorScheme(theme == .dark ? .dark : .light)
        .navigationViewStyle(.stack)
    }
}

//struct FeedbackAlertView: View {
//    @Binding var isPresented: Bool
//    @Binding var email: String
//    @Binding var message: String
//
//    var emailPlaceholder: String = ""
//    var messagePlaceholder: String = ""
//
//    let title: String
//    var action: ()->Void
//
//    let theme: ColorTheme
//    let language: Language
//    let shouldAdjustForKeyboard: Bool // Новый параметр
//
//    @State private var keyboardHeight: CGFloat = 0
//    @State private var alertViewHeight: CGFloat = 0
//
//    var body: some View {
//        ZStack {
//            if isPresented {
//                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
//                    .onTapGesture {
//                        isPresented = false
//                    }
//
//                VStack(alignment: .leading, spacing: 0) {
//                    Text(title)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(theme == .light ? Color.black : Color.white)
//                        .padding()
//                        .opacity(0.8)
//
//                    Divider()
//
//                    Text(Localization.text(.emailTitle, language: language))
//                        .font(.caption)
//                        .fontWeight(.regular)
//                        .foregroundColor(.gray)
//                        .padding(10)
//
//                    TextField(emailPlaceholder, text: $email)
//                        .disableAutocorrection(true)
//                        .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
//                        .textFieldStyle(.plain)
//                        .frame(height: 40)
//                        .padding(.horizontal, 9)
//
//                    Divider()
//
//                    Text(Localization.text(.messageTitle, language: language))
//                        .font(.caption)
//                        .fontWeight(.regular)
//                        .foregroundColor(.gray)
//                        .padding(10)
//
//                    CustomFeedbackTextEditor(placeholder: messagePlaceholder, text: $message, theme: theme)
//
//                    Divider()
//
//                    HStack{
//                        Button {
//                            isPresented = false
//                        } label: {
//                            Text(Localization.text(.cancel, language: language))
//                                .padding(.vertical, 14)
//                                .contentShape(.rect)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
//
//                        Divider()
//                            .frame(height: 50)
//
//                        Button {
//                            action()
//                        } label: {
//                            Text(Localization.text(.submit, language: language))
//                                .padding(.vertical, 14)
//                                .contentShape(.rect)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
//                        .disabled(message.isEmpty)
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.width / 1.4)
//                .background(theme == .light ? Color(hex: "F0F1F1") : Color(hex: "272727"))
//                .cornerRadius(16)
//                .background(
//                    GeometryReader { geometry in
//                        Color.clear
//                            .onAppear {
//                                alertViewHeight = geometry.size.height
//                            }
//                    }
//                )
//                .offset(y: shouldAdjustForKeyboard ? -keyboardHeight / 3 : 0)
//                .animation(.easeOut(duration: 0.16), value: keyboardHeight)
//                .onAppear {
//                    UITextView.appearance().backgroundColor = .clear
//
//                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//                        keyboardHeight = keyboardFrame.height
//                    }
//
//                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//                        keyboardHeight = 0
//                    }
//                }
//                .onDisappear {
//                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//                }
//
//                ButtonHideKeyboard()
//            }
//        }
//    }
//
//    private func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//            keyboardHeight = keyboardFrame.height
//        }
//
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//            keyboardHeight = 0
//        }
//    }
//
//    private func removeKeyboardObservers() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//}

struct CustomFeedbackTextEditor: View {
    var placeholder: String = "Denis"
    @Binding var text: String
    
    let theme: ColorTheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if #available(iOS 16.0, *) {
                TextEditor(text: $text)
                    .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .scrollContentBackground(.hidden)
                    .opacity(text.isEmpty ? 0.1 : 1)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 24))
            } else {
                TextEditor(text: $text)
                    .foregroundColor(theme == .light ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .opacity(text.isEmpty ? 0.1 : 1)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 24))
            }
            
            if text.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(.leading, 20)
                    .padding(.top, 24)
                    .allowsHitTesting(false)
            }
        }
    }
}

// Global Toast Manager and Container
import UIKit

final class GlobalToastManager {
    static let shared = GlobalToastManager()
    private init() {}

    func showToast<Content: View>(language: Language, theme: ColorTheme, @ViewBuilder content: @escaping () -> Content) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        let hosting = UIHostingController(rootView: GlobalToastContainer(content: content))
        hosting.view.backgroundColor = .clear
        hosting.view.clipsToBounds = false
        hosting.view.layer.cornerRadius = 12

        let width = window.frame.width * 0.9
        let maxHeight: CGFloat = 120
        let finalY: CGFloat = 80

        hosting.view.frame = CGRect(x: (window.frame.width - width) / 2,
                                    y: finalY,
                                    width: width,
                                    height: maxHeight)

        hosting.view.transform = CGAffineTransform(translationX: 0, y: -200)
        hosting.view.alpha = 0

        window.addSubview(hosting.view)

        UIView.animate(withDuration: 0.38, delay: 0, options: [.curveEaseOut], animations: {
            hosting.view.transform = .identity
            hosting.view.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.38, delay: 0, options: [.curveEaseIn], animations: {
                    hosting.view.transform = CGAffineTransform(translationX: 0, y: -200)
                    hosting.view.alpha = 0
                }, completion: { _ in
                    hosting.view.removeFromSuperview()
                })
            }
        })
    }
}

struct GlobalToastContainer<Content: View>: View {
    let content: () -> Content
    var body: some View {
        HStack {
            content()
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
//        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

#Preview{
    FeedbackSheetSendMessage(feedbackRepository: FeedbackRepository(), language: .en, theme: .dark, urlServer: "")
}

struct CustomToastSuccessfullyCopied: View {
    let language: Language
    let theme: ColorTheme
    var body: some View {
        Text(Localization.text(.successfulCopied, language: language))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundColor(theme == .light ? Color.black : Color.white)
            .background(theme == .light ? Color.white : Color(hex: "272727"))
            .clipShape(Capsule())
            .shadow(radius: theme == .light ? 5 : 0)
    }
}

struct CustomToastSuccessfullySendReport: View {
    let language: Language
    let theme: ColorTheme
    var body: some View {
        Text(Localization.text(.successfulSendReport, language: language))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundColor(theme == .light ? Color.black : Color.white)
            .background(theme == .light ? Color.white : Color(hex: "272727"))
            .clipShape(Capsule())
            .shadow(radius: theme == .light ? 5 : 0)
    }
}
