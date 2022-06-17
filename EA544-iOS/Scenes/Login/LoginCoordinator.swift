//
//  LoginCoordinator.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 6/16/22.
//

import UIKit

final class LoginCoordinator: Coordinator, LoginNavigation {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = LoginViewModel()
        let vc = LoginViewController.instantiate(viewModel: vm)
        vm.view = vc
        vm.navigation = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToHome() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
