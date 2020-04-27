//
//  FavortitesViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import Firebase

class AllMessagesViewController: UITableViewController {
    var users = [User]()
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        self.navigationItem.title = "Chats"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessage))
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: cellID)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func newMessage() {
        let newMessageVC = NewMessageViewController()
        newMessageVC.messageVC = self
        
        present(UINavigationController(rootViewController: newMessageVC), animated: true, completion: nil)
    }
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }
    func showViewController (user: User) {
        let chatlogVC = ChatLogViewController()
        chatlogVC.user = user
        chatlogVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatlogVC, animated: true)
        
    }

}

class NewMessageCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
