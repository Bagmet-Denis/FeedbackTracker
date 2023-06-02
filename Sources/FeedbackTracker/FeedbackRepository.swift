//
//  FeedbackRepository.swift
//  FeedbackApp
//
//  Created by Денис Багмет on 31.05.2023.
//

import Foundation

class FeedbackRepository: ObservableObject{
    @Published var email: String = "Email"
    @Published var message: String = "Message"
    
    let appName: String = Bundle.main.displayName ?? ""
    let urlPath: String = "http://89.108.99.148:8080"
    
    func sendFeedback() async{
        guard let url = URL(string: self.urlPath + "/feedback") else {return}

        let data = FeedbackModel(email: self.email, message: self.message, appName: self.appName)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONEncoder().encode(data)
        request.httpBody = jsonData

        do{
            let (_, _) = try await URLSession.shared.data(for: request)
        }catch{
            print(error.localizedDescription)
        }
    }
}
