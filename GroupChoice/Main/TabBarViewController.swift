//
//  TabBarViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var location = "not set"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let messagesViewController = UINavigationController(rootViewController: AllMessagesViewController())
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "message_grey"), selectedImage: #imageLiteral(resourceName: "message_blue"))
        
        let searchViewController = UINavigationController(rootViewController:SearchViewController())
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 25)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        searchViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "map_grey"), selectedImage: #imageLiteral(resourceName: "map_blue"))
        
        let createPollViewController =  CreatePollViewController()
        createPollViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "FAB"), selectedImage: #imageLiteral(resourceName: "FAB"))
        
        let mapViewController = UINavigationController(rootViewController: MapViewController())
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "search_grey"), selectedImage: #imageLiteral(resourceName: "search_blue"))
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Account_grey"), selectedImage: #imageLiteral(resourceName: "account_blue"))
        
        let viewControllerList = [searchViewController,messagesViewController, createPollViewController, mapViewController, settingsViewController]
        
        viewControllers = viewControllerList
        tabBar.barTintColor = .white
   
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
