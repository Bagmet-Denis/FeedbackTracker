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
        
        alert.textFields.forEach { textField in
            alertController.addTextField { [weak self] in
                guard let self = self else { return }
                $0.text = textField.text.wrappedValue
                $0.textPublisher.assign(to: \.text.wrappedValue, on: textField).store(in: &self.cancellables)
                $0.placeholder = textField.placeholder
                $0.isSecureTextEntry = textField.isSecureTextEntry
                $0.autocapitalizationType = textField.autocapitalizationType
                $0.autocorrectionType = textField.autocorrectionType
                $0.keyboardType = textField.keyboardType
            }
        }
        
        let customView = UITextView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50).isActive = true
        
        alertController.view.addSubview(customView)

        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60).isActive = true
        customView.backgroundColor = UIColor.red
        
        
        
        
        alert.actions.forEach { action in
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { [weak self, weak alertController] _ in
                    self?.alert.isPresented?.wrappedValue = false
                    action.closure?(alertController?.textFields?.map { $0.text ?? "" } ?? [])
                }
            )
            alertAction.isEnabled = action.isEnabled.wrappedValue
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true)
    }
}
