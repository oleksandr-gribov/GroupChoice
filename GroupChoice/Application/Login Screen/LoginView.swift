//
//  LoginView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/1/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
        let stackView = mainStackView()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.7)
            
        }
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            //make.leading.equalToSuperview().offset(50)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        let smallerStack = smallerStackView()
        addSubview(smallerStack)
        smallerStack.snp.makeConstraints { (make) in
            make.height.equalTo(29)
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.width.equalTo(232)
       
        }
    }
    
    let backgroundImageView: UIImageView =  {
        let iv = UIImageView()
        iv.image = UIImage(named: "architectural-design-architecture-birds-eye-view-1722183")
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Email", keyboardType: .emailAddress)
        return tf
    }()
    
    let incorrectLogin: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.red
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.setuploginTextField(placeHolderText: "Password", keyboardType: .default)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 150/255, green: 211/255, blue: 255/255, alpha: 1)
        btn.setAttributedTitle(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 22), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    let noAccountTextLabel: UITextView = {
        let tf = UITextView()
        tf.text = "Don't have an account?"
        tf.textColor = UIColor.white
        tf.font = UIFont(name: "Avenir Next", size: 13)
        tf.backgroundColor = UIColor.clear
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 22), NSAttributedString.Key.foregroundColor: UIColor(red: 150/255, green: 211/255, blue: 255/255, alpha: 1)]), for: .normal)
        return btn
    }()
    
    func mainStackView () -> UIStackView {
        let stv = UIStackView( arrangedSubviews: [emailTextField, passwordTextField, incorrectLogin])
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 10
        
        
        return stv
    }
    
    
    func smallerStackView() -> UIStackView {
        let stv = UIStackView(arrangedSubviews: [noAccountTextLabel, signUpButton])
        stv.axis = .horizontal
        stv.distribution = .fill
        return stv
    }
}
