//
//  VoteCreateViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/3/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class VoteCreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var checks: [String] = ["one", "two", "three"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell")!
        let item = checks[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
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
