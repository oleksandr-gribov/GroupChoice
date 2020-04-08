//
//  AddPlacesToVoteTableViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/8/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class AddPlacesToVoteTableViewController: UITableViewController, UISearchBarDelegate {
    
    var placesAdded : [Place]?
    var placesFound : [Place] = []
    var searchLocation = NearbyPlacesViewController.userLocation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false 
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "addPlacesCell")
        
        let searchbar = search.searchBar
        searchbar.barStyle = .blackTranslucent
        searchbar.delegate = self
        
        
        searchbar.isTranslucent = false
        searchbar.barTintColor = .white
        searchbar.tintColor = .white
        
        tableView.separatorInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .white
        
        
        
        self.navigationItem.title = "Search"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
        
        //self.navigationItem. = UISearchBar(frame: CGRect(x: 20, y: 10, width: 150, height: 100))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    @objc func addItems() {
        print("Add items pressed")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 20
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        
        return v
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywordString = searchBar.searchTextField.text
        fetchPlaces(endpoint: .general, keyword: keywordString)
        tableView.reloadData()
    }
    
    
    func fetchPlaces(endpoint: GooglePlacesAPI.Endpoint?, keyword:String?) {
        self.placesFound.removeAll()
        print("search location is \(searchLocation)")
        guard let currentLocation = searchLocation else {
            print ("no location in fetch places")
            return
        }
        guard let url = GooglePlacesAPI.makeUrl(endpoint: endpoint ?? GooglePlacesAPI.Endpoint.general, radius: 500, coordinate: currentLocation, keyword: keyword ?? nil) else {
            print("couldnt construct url")
            return
        }
        
        print(url)
        Network.fetchGenericData(url: url) { (response: Response) in
            if response.results.count != 0 {
                for place in response.results {
                    if !(self.placesFound.contains(place)) {
                        self.placesFound.append(place)
                    }
                }
                DispatchQueue.main.async {
                    print ("number of places fetched in fetchPlaces is \(self.placesFound.count)")
                    DispatchQueue.main.async {
                        print ("number of places fetched in fetchPlaces is \(self.placesFound.count)")
                        self.tableView.reloadData()
                    }
                }
            } else {
                
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addPlacesCell", for: indexPath) as! SearchTableViewCell
//        if let place = placesFound[indexPath.row] {
//            cell.textLabel?.text = place.name
//        }
     
        
    
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
