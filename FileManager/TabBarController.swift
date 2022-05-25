//
//  TabBarController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 21.05.2022.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        tabBar.tintColor = CustomColors.setColor(style: .dustyTeal) 
        delegate = self
        setupTabBar()
    }
    
    private func setupTabBar(){
        let settingsTab = SettingsViewController()
        settingsTab.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 0)
        let fileManagerTab = FileManagerViewController()
        fileManagerTab.tabBarItem = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.fill"), tag: 1)
        let settingsNavVC = UINavigationController(rootViewController: settingsTab)
        let fileManagerNavVC = UINavigationController(rootViewController: fileManagerTab)
        self.viewControllers = [settingsNavVC, fileManagerNavVC]
        
    }
}
