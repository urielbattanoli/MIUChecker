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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = ScannerViewModel()
        let vc = ScannerViewController.instantiate(viewModel: vm)
        vm.view = vc
        vm.navigation = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentMember(_ viewModel: MemberViewModel) {
        let vc = MemberViewController.instantiate(viewModel: viewModel)
        let navigation = AppNavigationController(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        navigationController.present(navigation, animated: true)
    }
}
