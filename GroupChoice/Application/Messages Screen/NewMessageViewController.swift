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
    var db : DocumentReference!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        if userList.isEmpty {
           fetchUsersFromDB()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "New Message"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewMessage))
        self.tableView.register(UserCell.self, forCellReuseIdentifier: userCellID)
        self.tableView.rowHeight = 65
        self.navigationController?.navigationBar.isTranslucent = false 
        ref = Database.database().reference()
    }
    
    @objc func cancelNewMessage() {
        self.dismiss(animated: true, completion: nil)
    }
    func fetchUsersFromDB() {
        ref.child("users").observe(DataEventType.childAdded, with: { (dataSnapshot) in
    
            if let usersDictionary = dataSnapshot.value as? [String: AnyObject] {
                let user = User()
                user.username = usersDictionary["username"] as? String
                user.email = usersDictionary["email"] as? String
                user.uid = dataSnapshot.key as? String
                if !self.userList.contains(user) {
                    self.userList.append(user)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("couldnt construct userDict")
            }
        })
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }
    // wrong
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
        openChat(user: user)
        
    }
    
    func openChat(user: User) {
        
        let currentUser = Auth.auth().currentUser!
        
        let chatKey = String(currentUser.uid + "_" + user.uid!)
        let searchRef = self.ref.child("conversations/chats").child(chatKey).observe(.value) { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
                
                
                self.dismiss(animated: true, completion: nil)
                // open the chat from all messages view controller
                
                // trigger an delegate method call
            } else {
                print("no such chat")
                let chatLogVC = ChatLogViewController()
                chatLogVC.recepeintUser = user
                self.navigationController?.pushViewController(chatLogVC, animated: true)
                //self.createNewChat(chatKey: chatKey, currentUser: currentUser, secondUser: user)
            }
        }
        
        
        // creating a new chat
       
        
        
    }
    // MOVE THIS TO CHATLOG VC
    
    /// Gets triggered when a new message is sent in the chat so as to not save empty chats
    private func createNewChat(chatKey: String, currentUser: Firebase.User, secondUser: User) {
        let currRef = self.ref.child("conversations").child("chats").child(chatKey)
               let dict = ["title":"some chat",
                           "lastMessage":"user2: having trouble connecting",
                           "timestamp":"123"] as [String : Any]

               currRef.updateChildValues(dict) { (Error, DatabaseReference) in

               }
               let membersRef = self.ref.child("conversations").child("members").child(chatKey).child("users")
               let values = [currentUser.uid : true,
                             secondUser.uid: true]

               membersRef.updateChildValues(values) { (err, db) in

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
