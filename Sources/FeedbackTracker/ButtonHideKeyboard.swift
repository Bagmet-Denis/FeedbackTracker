//
//  SwiftUIView.swift
//  FeedbackTracker
//
//  Created by Denis on 21.10.2025.
//

import SwiftUI

struct ButtonHideKeyboard: View {
    @State private var isKeyboardPresented: Bool = false
    let theme: ColorTheme
    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                Button {
                    closeKeyBoard()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(theme == .dark ? Color.white : Color.black)
                    }
                    .frame(width: 40, height: 40)
                }
                .glassEffect()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
            } else if #available(iOS 15.0, *) {
                Button {
                    closeKeyBoard()
                } label: {
                    ZStack{
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(theme == .dark ? Color.white : Color.black)
                    }
                    .contentShape(.rect)
                    .overlay(Circle().stroke(.ultraThinMaterial, lineWidth: 1))
                    .compositingGroup()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
            } else {
                Button {
                    closeKeyBoard()
                } label: {
                    ZStack{
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(theme == .dark ? Color.white : Color.black)
                    }
                    .contentShape(.rect)
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1))
                    .compositingGroup()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            withAnimation(.bouncy) {
                isKeyboardPresented = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.bouncy) {
                isKeyboardPresented = false
            }
        }
        .opacity(isKeyboardPresented ? 1 : 0)
        .disabled(!isKeyboardPresented)
    }
    
    private func closeKeyBoard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
