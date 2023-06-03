// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public extension View{
    func feedbackAlert(isPresented: Binding<Bool>) -> some View{
        TextFieldWrapper(isPresented: isPresented, presentingView: self) {
            TextFieldAlert(title: "test")
        }
    }
}

public func showActionSheet(completion: @escaping () -> Void) -> ActionSheet {
    let actionSheet = ActionSheet(
        title: Text("Custom ActionSheet"),
        message: Text("This is a custom action sheet."),
        buttons: [
            .default(Text("OK"), action: completion),
            .cancel()
        ]
    )
    return actionSheet
}
