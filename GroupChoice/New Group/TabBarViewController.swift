//
//  TabBarViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let messagesViewController = UINavigationController(rootViewController: MessagesViewController())
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "message_grey"), selectedImage: #imageLiteral(resourceName: "message_blue"))
        
        let searchViewController = UINavigationController(rootViewController:SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "search_grey"), selectedImage: #imageLiteral(resourceName: "search_blue"))
        
        let createPollViewController =  CreatePollViewController()
        createPollViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "FAB-1"), selectedImage: #imageLiteral(resourceName: "FAB-1"))
        
        let mapViewController = UINavigationController(rootViewController: MapViewController())
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "map_grey"), selectedImage: #imageLiteral(resourceName: "map_blue"))
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "account_grey"), selectedImage: #imageLiteral(resourceName: "account_blue"))
        
        let viewControllerList = [searchViewController,messagesViewController, createPollViewController, mapViewController, settingsViewController]
        
        viewControllers = viewControllerList
        tabBar.barTintColor = .white
        
        // comment
        
       
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: CreatePollViewController.self)  {
            let createViewController = CreatePollViewController()
            createViewController.modalPresentationStyle = .overFullScreen
            self.present(createViewController, animated: true, completion: nil)

            return false
        }
        return true
    }
    

}
