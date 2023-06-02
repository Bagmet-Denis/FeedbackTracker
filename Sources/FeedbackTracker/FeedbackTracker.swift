// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

//public struct FeedBackAlert: View{
//    @StateObject var feedbackRepository = FeedbackRepository()
//    public var body: some View{
//        
//    }
//}

public struct FeedBackAlert {
    public static func showAlert(completion: @escaping () -> Void) -> Alert {
        let alert = Alert(
            title: Text("Custom Alert"),
            message: Text("This is a custom alert."),
            primaryButton: .default(Text("OK"), action: completion),
            secondaryButton: .cancel()
        )
        return alert
    }
}
