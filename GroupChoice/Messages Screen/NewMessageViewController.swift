//
//  NewMessageViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/6/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    var userList = [User]()
    let userCellID = "userCellId"
    var ref: DatabaseReference!
    var messageVC: AllMessagesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "New Message"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewMessage))
        self.tableView.register(UserCell.self, forCellReuseIdentifier: userCellID)
        self.tableView.rowHeight = 65
        ref = Database.database().reference()
        fetchUsersFromDB()
        

    }
    
    @objc func cancelNewMessage() {
        self.dismiss(animated: true, completion: nil)
    }
    func fetchUsersFromDB() {
        ref.child("users").observe(DataEventType.childAdded, with: { (DataSnapshot) in
            //print (DataSnapshot)
            if let usersDictionary = DataSnapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.username = usersDictionary["username"] as? String
                user.email = usersDictionary["email"] as? String
                self.userList.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print ("couldnt construct userDict")
            }
        })
        
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! UserCell
        // Configure the cell...
        let user = userList[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        self.dismiss(animated: true) {
            self.messageVC.showViewController(user: user)
        }
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
