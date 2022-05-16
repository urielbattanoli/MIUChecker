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
        self.viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - InitialViewModelDelegate
extension InitialViewController: InitialViewModelDelegate {
    
    func openHome() {
        
    }
    
    func openLogin() {
        
    }
}
