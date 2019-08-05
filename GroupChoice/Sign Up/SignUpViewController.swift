//
//  SignUpViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/2/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var signUpView: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavbar()
        setupView()
        setTextFieldDelegate()
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(backgroundTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func signUpButtonClicked () {
        print ("signUp button pressed")
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    func setupView() {
        signUpView = SignUpView()
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.center.equalToSuperview()
        }
        
    }
    func setNavbar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Sign Up"
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    // MARK: - TextField Delegate Methods
    
    func setTextFieldDelegate() {
        signUpView.emailTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        signUpView.confirmPasswordField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpView.emailTextField {
            textField.resignFirstResponder()
            signUpView.passwordTextField.becomeFirstResponder()
        } else if textField == signUpView.passwordTextField {
            textField.resignFirstResponder()
            signUpView.confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
