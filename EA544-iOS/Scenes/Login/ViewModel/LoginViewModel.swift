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

final class LoginViewModel: LoginViewDelegate {
    
    weak var view: LoginViewModelDelegate?
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
        
    }
}
