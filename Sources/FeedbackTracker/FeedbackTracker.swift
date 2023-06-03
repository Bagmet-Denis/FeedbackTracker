// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public extension View{
    func feedbackAlert(title: String, isPresented: Binding<Bool>) -> some View{
        TextFieldWrapper(isPresented: isPresented, presentingView: self) {
            TextFieldAlert(title: title)
        }
    }
}
