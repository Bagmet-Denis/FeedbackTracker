//import UIKit
//import SwiftUI
//import Combine
//
//public final class TextFieldAlertViewController: UIViewController {
//
//    private let alert: TextFieldAlert
//    private var cancellables = Set<AnyCancellable>()
//
//    init(
//        alert: TextFieldAlert
//    ) {
//        self.alert = alert
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override public func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        presentAlertController()
//    }
//
//    private func presentAlertController() {
//        let alertController = UIAlertController(
//            title: alert.title,
//            message: alert.message,
//            preferredStyle: .alert
//        )
//
//        alert.textFields.forEach { textField in
//            alertController.addTextField { [weak self] in
//                guard let self = self else { return }
//                $0.text = textField.text.wrappedValue
//                $0.textPublisher.assign(to: \.text.wrappedValue, on: textField).store(in: &self.cancellables)
//                $0.placeholder = textField.placeholder
//                $0.isSecureTextEntry = textField.isSecureTextEntry
//                $0.autocapitalizationType = textField.autocapitalizationType
//                $0.autocorrectionType = textField.autocorrectionType
//                $0.keyboardType = textField.keyboardType
//            }
//        }
//
//
//
//
//
//        alert.actions.forEach { action in
//            let alertAction = UIAlertAction(
//                title: action.title,
//                style: action.style,
//                handler: { [weak self, weak alertController] _ in
//                    self?.alert.isPresented?.wrappedValue = false
//                    action.closure?(alertController?.textFields?.map { $0.text ?? "" } ?? [])
//                }
//            )
//            alertAction.isEnabled = action.isEnabled.wrappedValue
//            alertController.addAction(alertAction)
//        }
//
//        let customView = UITextView()
//        customView.translatesAutoresizingMaskIntoConstraints = false
//        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50).isActive = true
//
//        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
//        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
//        customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60).isActive = true
//        customView.backgroundColor = UIColor.red
//
//        alertController.view.autoresizesSubviews = true
//        alertController.view.addSubview(customView)
//
//        present(alertController, animated: true)
//    }
//}

import UIKit
import SwiftUI
import Combine

public final class TextFieldAlertViewController: UIViewController {
    
    private let alert: TextFieldAlert
    private var cancellables = Set<AnyCancellable>()
    
    init(
        alert: TextFieldAlert
    ) {
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlertController()
    }
    
    private func presentAlertController() {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        
        // Создаем пользовательский контроллер представления
        let customViewController = UIViewController()
        customViewController.view.backgroundColor = .clear
        
        // Создаем и настраиваем UITextField
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 14)
        customViewController.view.addSubview(textField)
        
        // Создаем и настраиваем UITextView
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        customViewController.view.addSubview(textView)
        
        // Создаем и настраиваем UIView для отступа
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.backgroundColor = UIColor.systemGray6
        customViewController.view.addSubview(spacerView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: customViewController.view.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: customViewController.view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: customViewController.view.trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 30),
            
            spacerView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            spacerView.leadingAnchor.constraint(equalTo: customViewController.view.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: customViewController.view.trailingAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 8), // Отступ между полями
            
            textView.topAnchor.constraint(equalTo: spacerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: customViewController.view.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: customViewController.view.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: customViewController.view.bottomAnchor, constant: -8)
        ])
        
        // Добавляем пользовательский контроллер представления в UIAlertController
        alertController.setValue(customViewController, forKey: "contentViewController")
        
        alert.actions.forEach { action in
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { [weak self, weak alertController] _ in
                    self?.alert.isPresented?.wrappedValue = false
                    let textFieldText = textField.text ?? ""
                    let textViewText = textView.text ?? ""
                    action.closure?([textFieldText, textViewText])
                }
            )
            alertAction.isEnabled = action.isEnabled.wrappedValue
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true)
        
        // Сделать автофокус на UITextField после отображения
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
    }
}
