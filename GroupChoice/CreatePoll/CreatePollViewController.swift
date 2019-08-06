//
//  CreatePollViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/2/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class CreatePollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .black
        navigationBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 500)
        view.addSubview(navigationBar)
        
        
        let navItem = UINavigationItem(title: "Create Poll")
        let cancelButton  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMessage))
        navItem.rightBarButtonItem = cancelButton
        navigationBar.items = [navItem]
        // Do any additional setup after loading the view.
    }

    
    @objc func cancelMessage() {
        self.dismiss(animated: true, completion: nil)
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
