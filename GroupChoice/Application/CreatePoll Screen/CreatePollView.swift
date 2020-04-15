//
//  CreatePollView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/3/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit

class CreatePollView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
       //addSubview(verticalStack)
        //addSubview(horizontalStack)
        //addSubview(expirationStack)
       // bringSubviewToFront(verticalStack)
        
        addSubview(nameTextField)
        bringSubviewToFront(nameTextField)
        
        expirationStack.addArrangedSubview(voteExpireLabel)
        expirationStack.addArrangedSubview(voteExpirationSwitch)
        datePickStack.addArrangedSubview(pickADateLabel)
        datePickStack.addArrangedSubview(datePicker)
        
        addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(nameTextField)
        verticalStack.addArrangedSubview(datePickStack)
        verticalStack.addArrangedSubview(expirationStack)
        verticalStack.addArrangedSubview(addChoicesLabel)

        verticalStack.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Create a name for the vote"
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        
        return dp
    }()
    
    let pickADateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pick date and time"
        
        return lbl
    }()
    
    let expirationDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.isHidden = true
        return dp
        
    }()
    
    let voteExpireLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Expire at the time of the event"
        return lbl
    }()
    
    let voteExpirationSwitch: UISwitch = {
        let voteSwitch = UISwitch()
        voteSwitch.isSelected = true
        
        return voteSwitch
    }()
    
    let addChoicesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Add choices: "
        return lbl
    }()
    
    let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .red
        stack.spacing = 10
        return stack
    }()
    
    let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    let expirationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    let datePickStack: UIStackView = {
           let stack = UIStackView()
           stack.axis = .horizontal
           stack.distribution = .fill
           return stack
       }()
    
}
