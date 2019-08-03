//
//  LoginViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/1/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true 
        setupView()
    }
    
    func setupView() {
        let mainView = LoginView(frame: self.view.frame)
        self.loginView = mainView
        self.view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        loginView.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func loginButtonPressed() {
        print("Login button Pressed")
        let tabBarViewController = TabBarViewController()
        self.navigationController?.pushViewController(TabBarViewController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
