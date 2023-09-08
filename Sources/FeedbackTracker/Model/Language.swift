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
    case copyEmail
    case successfulCopied
    case successfulSendReport
    case emailTitle
    case messageTitle
}

struct Localization {
    static func text(_ text: LanguageStr, language: Language) -> String {
        switch language {
        case .en:
            switch text{
            case .cancel: return "Cancel"
            case .titleSheet: return "Customer Service"
            case .quickFeedback: return "Send a quick message"
            case .sendToEmail: return "Contact by email"
            case .feedback: return "Send message"
            case .email: return "Email (if an answer is required)"
            case .emailTitle: return "Email:"
            case .message: return "Your Message"
            case .messageTitle: return "Message:"
            case .submit: return "Send"
            case .copyEmail: return "Copy Email"
            case .successfulCopied: return "Email copied to clipboard"
            case .successfulSendReport: return "Your message has been successfully sent. Thank you!"
            }
        case .ru:
            switch text{
            case .cancel: return "Отмена"
            case .titleSheet: return "Служба поддержки"
            case .quickFeedback: return "Отправить быстрое сообщение"
            case .sendToEmail: return "Связться по email"
            case .feedback: return "Отправить сообщение"
            case .email: return "Email (если требуется ответ)"
            case .emailTitle: return "Email:"
            case .message: return "Ваше сообщение"
            case .messageTitle: return "Сообщение:"
            case .submit: return "Отправить"
            case .copyEmail: return "Скопировать Email"
            case .successfulCopied: return "Email скопирован в буфер обмена"
            case .successfulSendReport: return "Ваше сообщение успешно отправлено. Спасибо!"
            }
        }
    }
}
