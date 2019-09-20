//
//  LoginViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/1/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    var loginView: LoginView!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true 
        setupView()
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
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
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(backgroundTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func loginButtonPressed() {
        guard let email = loginView.emailTextField.text else { return }
        guard let password = loginView.passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print (err.localizedDescription)
            } else {
                if let user = user {
                    self.userDefaults.set(true, forKey: "UserIsLoggedIn")
                    print("User \(user.user.uid) signed in " )
                    self.present(TabBarViewController(), animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func signUpButtonPressed() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            textField.resignFirstResponder()
            loginView.passwordTextField.becomeFirstResponder()
        } else  {
            textField.resignFirstResponder()
        }
        return true
    }
}
