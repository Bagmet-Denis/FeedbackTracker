// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
//public struct FeedBackAlert: View{
//    @StateObject var feedbackRepository = FeedbackRepository()
//    public var body: some View{
//        
//    }
//}

//public struct FeedBackAlert {
//    @StateObject var feedbackRepository = FeedbackRepository()
//    @State var showAlert: Bool = false
//    public func showAlert(completion: @escaping () -> Void) -> TextFieldAlert {
//        let alert = TextFieldAlert(title: "Test", textFields: [
//            .init(text: $feedbackRepository.email, placeholder: "email"),
//            .init(text: $feedbackRepository.message, placeholder: "message"),
//        ], actions: [
//            .init(title: "Cancel"),
//            .init(title: "Submit", closure: { _ in
//                Task{
//                    await feedbackRepository.sendFeedback()
//                }
//            })
//        ], isPresented: $showAlert)
//
//        return alert
//    }
//}

public extension View{
    func feedbackAlert(isPresented: Binding<Bool>) -> some View{
        TextFieldWrapper(isPresented: isPresented, presentingView: self) {
            TextFieldAlert(title: "Test")
        }
    }
}
