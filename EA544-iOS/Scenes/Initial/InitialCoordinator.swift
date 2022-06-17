//
//  InitialCoordinator.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 6/16/22.
//

import UIKit

final class InitialCoordinator: Coordinator, InitialNavigation {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = InitialViewModel()
        let vc = InitialViewController.instantiate(viewModel: vm)
        vm.navigation = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openCheckerHome() {
        let navigation = AppNavigationController.defaultIntantiation()
        let coordinator = ScannerCoordinator(navigationController: navigation)
        children.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
        navigationController.present(navigation, animated: true)
    }
    
    func openLogin() {
        let navigation = AppNavigationController.defaultIntantiation()
        let coordinator = LoginCoordinator(navigationController: navigation)
        children.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
        navigationController.present(navigation, animated: true)
    }
    
    func openMemberHome(_ member: Member) {
        let vm = MemberViewModel(member: member)
        let vc = MemberViewController.instantiate(viewModel: vm)
        vm.view = vc
        let navigation = AppNavigationController.defaultIntantiation()
        navigation.pushViewController(vc, animated: false)
        navigationController.present(navigation, animated: true)
    }
    
    func logout() {
        navigationController.dismiss(animated: false)
        start()
    }
}
