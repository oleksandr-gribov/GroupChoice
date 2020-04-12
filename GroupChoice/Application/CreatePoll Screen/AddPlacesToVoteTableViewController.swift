//
//  AddPlacesToVoteTableViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/8/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class AddPlacesToVoteTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, SearchTableViewCellDelegate {
    
    weak var searchCompleteDelegate:SearchCompleteDelegate!

    var placesAdded : [Place] = []
    var placesFound : [Place] = []
    var searchLocation = NearbyPlacesViewController.userLocation
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "addPlacesCell")
        setupSearch()
        
        
        fetchPlaces(endpoint: .general, keyword: "")
        tableView.reloadData()
        

        self.navigationItem.title = "Search"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dloneButtonPressed))
        
    }
    func setupSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = .white
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        
        let searchbar = searchController.searchBar
        searchController.searchBar.tintColor = .white
        searchbar.placeholder = "e.g. Coffee, Pizza, Gym"
        searchbar.searchTextField.textColor = .white
        
        searchbar.becomeFirstResponder()
      
        
    }

    // MARK: - Search
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
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searching")
        var keywordString = searchController.searchBar.text
        keywordString = keywordString!.trimmingCharacters(in: .whitespacesAndNewlines)
        if keywordString != "" {
            fetchPlaces(endpoint: .general, keyword: keywordString)
            tableView.isHidden = false
            
            tableView.reloadData()
            
        }
    }
    // MARK: - Helper functions
    func findPlaceIndex(_ place: Place) -> Int? {
        var index = 0
        for addedPlace in placesAdded {
            if addedPlace.id != place.id {
                index += 1
            } else {
                return index
            }
        }
        return nil
    }
    
    @objc func dloneButtonPressed() {
           searchCompleteDelegate.onDoneButtonPressed(placesAdded)
           _ = navigationController?.popViewController(animated: true)
       }
    
    
    // MARK: - Table View Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return placesFound.count
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addPlacesCell", for: indexPath) as! SearchTableViewCell
        let place = placesFound[indexPath.section]
        cell.setUpCellData(place)
        if placesAdded.contains(place) {
            cell.buttonChecked = true
            cell.addButton.setImage(UIImage(named: "blue_check"), for: .normal)
        }
        cell.place = place
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placesFound[indexPath.section]
        let vc = PlaceDetailViewController()
        vc.place = place
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK: - SeacrhComplete protocol functions
    func searchTableViewCell(_ buttonChecked: Bool, place: Place) {
           if buttonChecked && !placesAdded.contains(place){
               placesAdded.append(place)
           } else {
               if placesAdded.contains(place) {
                   placesAdded.remove(at: findPlaceIndex(place)!)
               }
           }
       }
}


// MARK: - SearchComplete Protocol

protocol SearchCompleteDelegate: AnyObject {
    func onDoneButtonPressed(_ placesAdded: [Place])
}
