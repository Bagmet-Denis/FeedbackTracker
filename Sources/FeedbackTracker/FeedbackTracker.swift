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

public extension View {
    func addFeedback<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        self.background(Color.green)
    }
}
