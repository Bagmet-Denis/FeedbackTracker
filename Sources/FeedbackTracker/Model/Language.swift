//
//  File.swift
//  
//
//  Created by Денис Багмет on 03.06.2023.
//

import Foundation

public enum Language {
    case en
    case ru
}

enum LanguageStr {
    case titleSheet
    case quickFeedback
    case sendToEmail
    case cancel
}

struct Localization {
    static func text(_ text: LanguageStr, language: Language) -> String {
        switch language {
        case .en:
            switch text{
            case .titleSheet: return "Feedback"
            case .quickFeedback: return "Quick Feedback"
            case .sendToEmail: return "Send to Email"
            case .cancel: return "Cancel"
            }
        case .ru:
            switch text{
            case .titleSheet: return "Отзыв"
            case .quickFeedback: return "Быстрая обратная связь"
            case .sendToEmail: return "Отправить по электронной почте"
            case .cancel: return "Отмена"
            }
        }
    }
}
