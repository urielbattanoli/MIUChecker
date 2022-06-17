//
//  AppDelegate.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let nav = AppNavigationController()
        appCoordinator = InitialCoordinator(navigationController: nav)
        appCoordinator?.start()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
}
