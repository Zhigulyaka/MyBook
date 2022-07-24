//
//  AppDelegate.swift
//  Art
//
//  Created by Zhigulyaka on 20.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
            let discoverVC = ViewController() as UIViewController
        let tabBar = UITabBarController()
            let navigationController = UINavigationController(rootViewController: discoverVC)
            navigationController.navigationBar.isTranslucent = false
            self.window?.rootViewController = TabBarViewController()
            self.window?.makeKeyAndVisible()
        
        return true
    }
}

