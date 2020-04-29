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
    var settingsView : SettingsView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutPressed))
    }
    
    func setupView() {
        let mainView = SettingsView()
        settingsView = mainView
        self.view.addSubview(settingsView)
        view.bringSubviewToFront(settingsView)
        settingsView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let gradientLayer = CAGradientLayer()
              //backgroundColor = .white
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 150/255, green: 211/255, blue: 255/255, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
              
              
        self.view.layer.addSublayer(gradientLayer)
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
