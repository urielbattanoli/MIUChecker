//
//  LoginViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

protocol LoginViewModelDelegate: AppViewModelDelegate {
    
    func showEmailErrorMessage(_ message: String)
    func showPasswordErrorMessage(_ message: String)
}

protocol LoginNavigation: AnyObject {
    func didLogin()
}

final class LoginViewModel: LoginViewDelegate {
    
    weak var view: LoginViewModelDelegate?
    weak var navigation: LoginNavigation?
    var email = ""
    var password = ""
    
    func isValid(showError: Bool) -> Bool {
        guard showError else {
            return email.isValidEmail() && password.isValidPassword()
        }
        guard !email.isEmpty else {
            view?.showEmailErrorMessage("Required")
            return false
        }
        guard email.isValidEmail() else {
            view?.showEmailErrorMessage("Invalid email")
            return false
        }
        guard !password.isEmpty else {
            view?.showPasswordErrorMessage("Required")
            return false
        }
        guard password.isValidPassword() else {
            view?.showPasswordErrorMessage("Invalid password")
            return false
        }
        return true
    }
    
    func login() {
        guard isValid(showError: true) else { return }
        view?.startLoading(completion: nil)
        let info = "\(email):\(password)"
        API<EmptyResult>.login.request(params: ["username": email, "password": password], completion: { [weak self] response in
            self?.view?.stopLoading(completion: {
                switch response {
                case .success:
                    if let data = info.data(using: String.Encoding.utf8) {
                        Defaults.shared.token = "Basic " + data.base64EncodedString()
                    }
                    self?.navigation?.didLogin()
                case .failure(let error):
                    self?.view?.error(message: error.localizedDescription)
                }
            })
        })
    }
}
