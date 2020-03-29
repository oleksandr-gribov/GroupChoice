//
//  SignUpViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/2/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var signUpView: SignUpView!
    let userDefaults = UserDefaults.standard
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
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
        guard let email = signUpView.emailTextField.text,
            let password = signUpView.passwordTextField.text,
            let username = signUpView.nameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, err in
            if let err = err {
                print (err.localizedDescription)
                return
            } else {
                if let user = user {
                    self.userDefaults.set(false, forKey: "UserIsLoggedIn")
                    print ("created user : \(user.user.uid)")
                    self.navigationController?.popViewController(animated: true)
                    
                    self.ref = Database.database().reference(fromURL: "https://groupchoice-18b05.firebaseio.com/")
                    let userRef = self.ref.child("users").child(user.user.uid)
                    let values = ["username": username, "email":email]
                    userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print (error?.localizedDescription)
                            return
                        } else {
                            print("Saved user into the Firebase db")
                        }
                    })
                }
            }
        }
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    func setupView() {
        signUpView = SignUpView()
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    func setNavbar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Sign Up"
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
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
