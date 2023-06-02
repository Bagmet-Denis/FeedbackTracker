//
//  FeedbackModel.swift
//  FeedbackApp
//
//  Created by Денис Багмет on 31.05.2023.
//

import Foundation

struct FeedbackModel: Encodable{
    let email: String
    let message: String
    let appName: String
    
    public enum CodingKeys: String, CodingKey {
        case email
        case message
        case appName = "app_name"
    }
}
