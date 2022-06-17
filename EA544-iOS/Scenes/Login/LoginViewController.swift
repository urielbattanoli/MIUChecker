//
//  LoginViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    
    var view: LoginViewModelDelegate? { get set }
    var email: String { get set }
    var password: String { get set }
    
    func isValid(showError: Bool) -> Bool
    func login()
}

final class LoginViewController: AppViewController {
    
    static func instantiate(viewModel: LoginViewDelegate) -> LoginViewController {
        return LoginViewController(viewModel: viewModel)
    }
    
    @IBOutlet private weak var emailInputView: InputView!
    @IBOutlet private weak var passwordInputView: InputView!
    @IBOutlet private weak var loginButton: MainButton!
    @IBOutlet private weak var bottomButtonConstraint: NSLayoutConstraint!
    
    private let viewModel: LoginViewDelegate
    
    private init(viewModel: LoginViewDelegate) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        title = "Login"
        emailInputView.textChanged = { [weak self] in self?.emailTextChanged() }
        emailInputView.headerLabel.text = "Email"
        emailInputView.textField.placeholder = "Type your email"
        emailInputView.inputType = .email
        emailInputView.delegate = self
        passwordInputView.textChanged = { [weak self] in self?.passwordTextChanged() }
        passwordInputView.inputType = .password
        passwordInputView.headerLabel.text = "Password"
        passwordInputView.textField.placeholder = "Type your password"
        passwordInputView.textField.returnKeyType = .go
        passwordInputView.delegate = self
        loginButton.setTitle("Login", for: .normal)
        changeButtonState()
        startObservingKeyboard()
    }
    
    private func changeButtonState() {
        let isValid = viewModel.isValid(showError: false)
        loginButton.alpha = isValid ? 1 : 0.6
    }
    
    private func emailTextChanged() {
        emailInputView.hideErrorMessage()
        viewModel.email = emailInputView.text ?? ""
        changeButtonState()
    }
    
    private func passwordTextChanged() {
        passwordInputView.hideErrorMessage()
        viewModel.password = passwordInputView.text ?? ""
        changeButtonState()
    }
    
    @IBAction private func viewTouched(_ sender: UIControl) {
        view.endEditing(true)
    }
    
    @IBAction private func loginTouched(_ sender: UIButton) {
        viewModel.login()
    }
}

// MARK: - InputViewDelegate
extension LoginViewController: InputViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) {
        switch textField {
        case emailInputView.textField:
            passwordInputView.textField.becomeFirstResponder()
        case passwordInputView.textField:
            viewModel.login()
        default: break
        }
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    
    func showEmailErrorMessage(_ message: String) {
        emailInputView.showErrorMessage(message)
    }
    
    func showPasswordErrorMessage(_ message: String) {
        passwordInputView.showErrorMessage(message)
    }
}

extension LoginViewController: KeyboardObserverDelegate {
    
    func keyboardWillShow(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
        bottomButtonConstraint.constant = frame.height
        view.layoutIfNeeded()
    }
    
    func keyboardWillHide(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
        bottomButtonConstraint.constant = 44
        view.layoutIfNeeded()
    }
}
