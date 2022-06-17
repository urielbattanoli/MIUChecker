//
//  AppNavigationController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

final class AppNavigationController: UINavigationController {
    
    static func defaultIntantiation() -> AppNavigationController {
        let navigation = AppNavigationController()
        navigation.isNavigationBarHidden = true
        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve
        return navigation
    }
}
