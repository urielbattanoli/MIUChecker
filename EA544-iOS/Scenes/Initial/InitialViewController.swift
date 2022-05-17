//
//  InitialViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

final class InitialViewController: AppViewController {
    
    private var viewModel: InitialViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(viewModel: InitialViewModel) {
        self.init(nibName: .none, bundle: Bundle(for: Self.self))
        self.viewModel = viewModel
        self.viewModel.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenLogout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.route()
    }
    
    private func listenLogout() {
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name.init("application_logout"),
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                            self?.viewModel.logout()
        })
    }
}

// MARK: - InitialViewModelDelegate
extension InitialViewController: InitialViewModelDelegate {
    
    func openCheckerHome() {
        ScannerViewController.present(in: self, viewModel: ScannerViewModel())
    }
    
    func openMemberHome() {
        MemberViewController.present(in: self, viewModel: MemberViewModel())
    }
    
    func openLogin() {
        LoginViewController.present(in: self, viewModel: LoginViewModel())
    }
}
