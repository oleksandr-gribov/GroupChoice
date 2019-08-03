//
//  UITextField+Extension.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/1/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit


extension UITextField {
    
    func setuploginTextField ( placeHolderText: String, keyboardType: UIKeyboardType){
        
       
        self.keyboardType = keyboardType
        //self.borderStyle = .none
       
        let placeholder = NSAttributedString(attributedString: NSAttributedString(string: placeHolderText,
                                                                                       attributes: [
                                                                                        NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 22),.foregroundColor: UIColor.white]))
        self.attributedPlaceholder = placeholder
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.15)
        self.font = UIFont(name: "Avenir Next", size: 22)
        self.textColor = .white
        self.layer.cornerRadius = 10
        self.autocorrectionType = .no
    }
    func setLeftPadding (space: CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
        self.leftView = leftView
        self.leftViewMode = .always
        
    }
}
