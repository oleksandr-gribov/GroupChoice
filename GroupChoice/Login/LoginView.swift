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
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let stackView = mainStackView()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            //make.leading.equalToSuperview().offset(62)
            //make.trailing.equalToSuperview().offset(-62)
            make.height.equalTo(142)
            make.width.equalTo(275)
            
        }
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(128)
            make.trailing.equalToSuperview().offset(-128)
            make.bottom.equalToSuperview().offset(-181)
            make.height.equalTo(52)
        }
        let smallerStack = smallerStackView()
        addSubview(smallerStack)
        smallerStack.snp.makeConstraints { (make) in
            make.height.equalTo(29)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-106)
            make.width.equalTo(232)
       
        }
    }
    
    let backgroundImageView: UIImageView =  {
        let iv = UIImageView()
        iv.image = UIImage(named: "aerial-architecture-blue-sky-466685")
        iv.contentMode = .scaleAspectFill
        
        return iv
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
        let stv = UIStackView( arrangedSubviews: [emailTextField, passwordTextField])
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 10
        
        
        return stv
    }
    
    
    func smallerStackView() -> UIStackView {
        let stv = UIStackView(arrangedSubviews: [noAccountTextLabel, signUpButton])
        stv.axis = .horizontal
        stv.distribution = .fill
//        stv.spacing = 10
        return stv
    }
}
