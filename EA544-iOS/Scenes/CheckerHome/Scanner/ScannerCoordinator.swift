//
//  ScannerCoordinator.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 6/16/22.
//

import UIKit

final class ScannerCoordinator: Coordinator, ScannerNavigation {
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let viewModel = ScannerViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ScannerViewController.instantiate(viewModel: viewModel)
        viewModel.view = vc
        viewModel.navigation = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentMember(_ viewModel: MemberViewModel) {
        let vc = MemberViewController.instantiate(viewModel: viewModel)
        let navigation = AppNavigationController(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        navigationController.present(navigation, animated: true)
    }
    
    func presentLogin() {
        let navigation = AppNavigationController()
        let coordinator = LoginCoordinator(navigationController: navigation, delegate: viewModel)
        children.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
        navigationController.present(navigation, animated: true)
    }
}
