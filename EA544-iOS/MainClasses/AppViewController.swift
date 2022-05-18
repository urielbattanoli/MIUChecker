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
    
    func stopLoading(completion: (() -> Void)?) {
        guard var topController = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow})
                .first?
                .rootViewController else { return }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        guard let controller = topController as? UIAlertController else { return }
        controller.dismiss(animated: true, completion: completion)
    }
    
    func startLoading(completion: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .large
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: completion)
    }
    
    func error(message: String?) {
        showSimpleAlertController("Ops",
                                  message: message ?? "Something went wrong",
                                  actions: nil,
                                  cancel: false,
                                  style: .alert)
    }
    
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
