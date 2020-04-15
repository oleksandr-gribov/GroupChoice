//
//  SettingsViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutPressed))
    }
    
    @objc func logoutPressed () {
        do {
            try Auth.auth().signOut()
            userDefaults.set(false, forKey: "UserIsLoggedIn")
            let loginViewController = UINavigationController(rootViewController: LoginViewController())
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true, completion: nil)
        } catch let err {
            print(err)
        }
    }
}
