//
//  TabBarViewController.swift
//  Art
//
//  Created by Alina Kharunova on 22.07.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - Properties

    public var selectedIndexOfTab = 0 {
        didSet {
            selectedIndex = selectedIndexOfTab
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: - Configure

    private func configureControllers() {
        let tabBarAppearance: UITabBarAppearance = .init()
        tabBarAppearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        tabBar.clipsToBounds = true

        let warehouse = UINavigationController(rootViewController: ViewController())
        warehouse.tabBarItem = UITabBarItem(title: "L10n.warehouse",
                                            image: UIImage(named: "explore"),
                                            selectedImage: UIImage(named: "explore"))

        let moving = UINavigationController(rootViewController: ViewController())
        moving.tabBarItem = UITabBarItem(title: "10n.transfer",
                                         image: UIImage(named: "addBook"),
                                         selectedImage: UIImage(named: "addBook"))

        setViewControllers([moving, warehouse], animated: false)
        selectedIndex = selectedIndexOfTab
    }
}
