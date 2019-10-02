//
//  ChatLogViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/27/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MessageKit

class ChatLogViewController: MessagesViewController {
    
    var user: User! {
        didSet {
            self.navigationItem.title = user.username
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // need to set up view to have the input text field and the table view
        
    }

}

