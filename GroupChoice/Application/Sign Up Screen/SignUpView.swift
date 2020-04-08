//
//  SignUpView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/2/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been initialized ")
    }
    
    func setup() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let mainStack = mainStackView()
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalToSuperview().multipliedBy(0.7)
            
        }
        addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainStack.snp.bottom).offset(50)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

    }
    
    let backgroundImageView: UIImageView =  {
        let iv = UIImageView()
        iv.image = UIImage(named: "login_post")
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Username", keyboardType: .emailAddress)
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Email", keyboardType: .emailAddress)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Password", keyboardType: .default)
        tf.isSecureTextEntry = true
        return tf
    }()
    let confirmPasswordField : UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Confirm Password", keyboardType: .default)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 150/255, green: 211/255, blue: 255/255, alpha: 1)
        btn.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 22), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    
    
    func mainStackView () -> UIStackView {
        let stv = UIStackView( arrangedSubviews: [nameTextField, emailTextField, passwordTextField, confirmPasswordField])
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 10
        return stv
    }
}

