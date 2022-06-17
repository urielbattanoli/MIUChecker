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
    func goToHome()
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
        API<Authorization>.login.request(params: ["grant_type": "password", "username": email, "password": password], completion: { [weak self] response in
            switch response {
            case .success(let authorization):
                self?.loadUser(token: authorization.access_token)
            case .failure(let error):
                self?.view?.stopLoading(completion: {
                    self?.view?.error(message: error.localizedDescription)
                })
            }
        })
    }
    
    private func loadUser(token: String) {
        Defaults.shared.token = "Bearer " + token
        API<Member>.members(id: "62840a678c24ef569751ccc7").request(completion: { [weak self] response in
            self?.view?.stopLoading(completion: {
                switch response {
                case .success(let member):
                    Member.current = member
                    self?.navigation?.goToHome()
                case .failure(let error):
                    self?.view?.error(message: error.localizedDescription)
                }
            })
        })
    }
}
