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
    case feedback
    case email
    case message
    case submit
}

struct Localization {
    static func text(_ text: LanguageStr, language: Language) -> String {
        switch language {
        case .en:
            switch text{
            case .titleSheet: return "Customer Service"
            case .quickFeedback: return "Send a quick message"
            case .sendToEmail: return "Contact by email"
            case .cancel: return "Cancel"
            case .feedback: return "Send message"
            case .email: return "Your Email (if an answer is required)"
            case .message: return "Your Message"
            case .submit: return "Send"
            }
        case .ru:
            switch text{
            case .titleSheet: return "Служба поддержки"
            case .quickFeedback: return "Отправить быстрое сообщение"
            case .sendToEmail: return "Связться по email"
            case .cancel: return "Отмена"
            case .feedback: return "Отправить сообщение"
            case .email: return "Ваш Email (если требуется ответ)"
            case .message: return "Ваше сообщение"
            case .submit: return "Отправить"
            }
        }
    }
}
