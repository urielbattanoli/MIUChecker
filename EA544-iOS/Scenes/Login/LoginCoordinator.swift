//
//  LoginCoordinator.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 6/16/22.
//

import UIKit

protocol LoginDelegate: AnyObject {
    func didLogin()
}

final class LoginCoordinator: Coordinator, LoginNavigation {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    private weak var delegate: LoginDelegate?
    
    init(navigationController: UINavigationController, delegate: LoginDelegate? = nil) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    func start() {
        let vm = LoginViewModel()
        let vc = LoginViewController.instantiate(viewModel: vm)
        vm.view = vc
        vm.navigation = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didLogin() {
        navigationController.dismiss(animated: true) {
            self.delegate?.didLogin()
        }
        parentCoordinator?.childDidFinish(self)
    }
}
