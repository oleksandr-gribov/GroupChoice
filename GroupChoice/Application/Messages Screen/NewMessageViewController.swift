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
    var currentUser: User!
    

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
        currentUser = TabBarViewController.self.currentUser
        
        fetchUsersFromDB()
    }
    
    @objc func cancelNewMessage() {
        self.dismiss(animated: true, completion: nil)
    }
    func fetchUsersFromDB() {
        ref.child("users").observe(DataEventType.childAdded, with: { (dataSnapshot) in
    
            if let usersDictionary = dataSnapshot.value as? [String: AnyObject] {
                
                let username = usersDictionary["username"] as! String
                let email = usersDictionary["email"] as! String
                let uid = dataSnapshot.key
                
                let user = User(uid: uid, username: username, email: email)
                
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
        print("number of users is \(userList.count)")
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
        print(user.email)
        openChat(user: user)
        
    }
    func fetchUserData(userID: String, completion: @escaping (User?) -> ()) {
        ref.child("users").observe(.value){ (snapshot, err) in
            if let err = err {
                completion(nil)
            }
            for child in snapshot.children {
                if let firebaseUser = child as? DataSnapshot {
                    if firebaseUser.key == userID {
                        let email = firebaseUser.childSnapshot(forPath: "email").value as! String
                        let username = firebaseUser.childSnapshot(forPath: "username").value as! String
                        completion(User(uid: firebaseUser.key, username: username, email: email))
                    }
                }
            }
        }
    }
    
    func openChat(user: User) {
        
        let currentUser = Auth.auth().currentUser!
        var mainUser: User?
        
        self.fetchUserData(userID: currentUser.uid) { (User) in
            if let user  = User {
                mainUser = user
            } else {
                return
            }
        }
        
        
        
        var chatKey = ""
        if currentUser.uid > user.uid! {
           chatKey = currentUser.uid + "_" + user.uid!
        } else {
            chatKey = user.uid! + "_"  + currentUser.uid
        }
        
        let searchRef = self.ref.child("conversations/chats").child(chatKey).observe(.value) { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
                
                
                self.dismiss(animated: true, completion: nil)
                // open the chat from all messages view controller
                
                // trigger a delegate method call
            } else {
                print("no such chat")
                let newChat = Chat(chatID: chatKey, users: [mainUser!, user], chatTitle: user.username, lastMessage: nil)
                let chatLogVC = ChatLogViewController()
                chatLogVC.secondUser = user
                chatLogVC.isNewChat = true
                
                self.navigationController?.pushViewController(chatLogVC, animated: true)
                //self.createNewChat(chatKey: chatKey, currentUser: currentUser, secondUser: user)
            }
        }
        
        
        // creating a new chat
       
        
        
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
