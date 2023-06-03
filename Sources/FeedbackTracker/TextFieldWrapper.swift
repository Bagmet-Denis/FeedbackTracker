import SwiftUI

struct TextFieldWrapper<PresentingView: View>: View {
    @StateObject var feedbackRepository = FeedbackRepository()
    let title: String
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert
    
    var body: some View {
        ZStack {
            if isPresented {
                TextFieldAlert(title: title, textFields: [
                    .init(text: $feedbackRepository.email, placeholder: "email"),
                    .init(text: $feedbackRepository.message, placeholder: "message"),
                ], actions: [
                    .init(title: "Cancel"),
                    .init(title: "Submit", closure: { _ in
                        Task{
                            await feedbackRepository.sendFeedback()
                        }
                    })
                ])
                .dismissible($isPresented)
            }
            
            presentingView
        }
    }
}
