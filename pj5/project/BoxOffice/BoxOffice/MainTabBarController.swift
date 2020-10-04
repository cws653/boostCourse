//
//  MainTabBarController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/10/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let viewController = self.viewControllers?[self.selectedIndex] as? UINavigationController else {
            return
        }
        viewController.popToRootViewController(animated: false)
    }
}
