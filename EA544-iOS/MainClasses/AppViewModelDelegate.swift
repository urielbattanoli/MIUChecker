//
//  AppViewModelDelegate.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol AppViewModelDelegate: AnyObject {
    func stopLoading(completion: (() -> Void)?)
    func startLoading(completion: (() -> Void)?)
    func pushToVC(_ vc: UIViewController)
    func pop()
    func presentVC(_ vc: UIViewController)
    func dismiss()
    
    func error(message: String?)
    func showSimpleAlertController(_ title: String?, message: String?, actions: [UIAlertAction]?, cancel: Bool, style: UIAlertController.Style)
}
