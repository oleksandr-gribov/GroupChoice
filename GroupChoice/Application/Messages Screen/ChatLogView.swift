//
//  ChatLogView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/27/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class ChatLogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been initialized ")
    }
    
    func setup() {
        addSubview(inputTF)
        addSubview(messagesTableView)
        addSubview(sendButton)
        
    }
    
    let inputTF: UITextField = {
        let tf = UITextField()
        
        return tf
    }()
    
    let messagesTableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    let sendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", for: .normal)
        
        return btn
    }()
}
