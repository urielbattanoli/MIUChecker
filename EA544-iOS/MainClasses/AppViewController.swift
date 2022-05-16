//
//  AppViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

class AppViewController: UIViewController {
    
}

// MARK: - AppViewModelDelegate
extension AppViewController: AppViewModelDelegate {
    
    func showSimpleAlertController(_ title: String?, message: String?, actions: [UIAlertAction]?, cancel: Bool, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let actions: [UIAlertAction] = actions ?? []
        
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: cancel ? "Cancel" : "Ok", style: .cancel))
        } else {
            actions.forEach { alert.addAction($0) }
            if cancel { alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)) }
        }
        
        present(alert, animated: true)
    }
    
    func pushToVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentVC(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
