//
//  ChatLogViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/27/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class ChatLogViewController: UIViewController {
    
    var user: User! {
        didSet {
            self.navigationItem.title = user.username
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = true 
        
        // need to set up view to have the input text field and the table view
        
    }

}
