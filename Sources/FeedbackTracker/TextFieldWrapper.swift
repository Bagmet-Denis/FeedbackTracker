import SwiftUI

struct TextFieldWrapper<PresentingView: View>: View {
    @StateObject var feedbackRepository = FeedbackRepository()
    @Binding var isPresented: Bool
    let urlServer: String
    let language: Language
    let presentingView: PresentingView
    let content: () -> TextFieldAlert
    
    var body: some View {
        ZStack {
            if isPresented {
                TextFieldAlert(title: Localization.text(.feedback, language: language), textFields: [
                    .init(text: $feedbackRepository.email, placeholder: Localization.text(.email, language: language)),
                    .init(text: $feedbackRepository.message, placeholder: Localization.text(.message, language: language)),
                ], actions: [
                    .init(title: Localization.text(.cancel, language: language)),
                    .init(title: Localization.text(.submit, language: language), closure: { _ in
                        Task{
                            await feedbackRepository.sendFeedback(urlPath: urlServer)
                        }
                    })
                ])
                .dismissible($isPresented)
            }
            
            presentingView
        }
    }
}
