//
//  BookmarksViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: BaseViewControllerWithLocation, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    var mainView: UIView!
    var currentPlace: Place?
    var mapSearchView: MapSearchView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsTextField: UITextField!
    
    
    let options = ["restaurant":GooglePlacesAPI.Endpoint.restaurant, "cafe":GooglePlacesAPI.Endpoint.cafe, "bar":GooglePlacesAPI.Endpoint.bar, "gym":GooglePlacesAPI.Endpoint.gym, "night club": GooglePlacesAPI.Endpoint.nightClub, "museum":GooglePlacesAPI.Endpoint.museum, "amusement park": GooglePlacesAPI.Endpoint.amusementPark, "art gallery": GooglePlacesAPI.Endpoint.artGallery, "park": GooglePlacesAPI.Endpoint.park, "bowling alley": GooglePlacesAPI.Endpoint.bowlingAlley]
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().barTintColor = .red
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "top blur"), for: .default)
        if self.placesNearby.isEmpty {
            checkLocationServices()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        setupView()
        view.sendSubviewToBack(mapSearchView)
        
        setupSearch()
                
        //self.navigationController?.navigationBar.backgroundColor = .purple
        
       
        self.navigationItem.title = "Search"
        
        let d = navigationController?.navigationBar.frame.size.height
        print("height of nav controller is \(d)")
        self.mapSearchView.topSquare.snp.updateConstraints { (make) in
            make.height.equalTo(d!)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: optionsCellID)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        mapView.delegate = self
        optionsTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        optionsTextField.isUserInteractionEnabled = true
        optionsTextField.addGestureRecognizer(tapGestureRecognizer)
        
        let customViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customViewTapped))
        self.mapSearchView.customView.addGestureRecognizer(customViewTapGestureRecognizer)
        
        let customSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(customViewSwiped))
        customSwipeGestureRecognizer.direction = .down
        self.mapSearchView.customView.addGestureRecognizer(customSwipeGestureRecognizer)
        
    }
    private func setupView() {
         mapSearchView = MapSearchView()
         view.addSubview(mapSearchView)
        self.mapView = mapSearchView.mapView

         self.mapView.frame = self.view.bounds

         mapSearchView.snp.makeConstraints { (make) in
             make.left.equalToSuperview()
             make.right.equalToSuperview()
            make.top.equalToSuperview()
             make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
         }
         optionsTextField = mapSearchView.optionsLabel
         tableView = mapSearchView.tableView

         mapView.isUserInteractionEnabled = true
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
    
    @objc func customViewSwiped() {
        self.mapSearchView.customView.isHidden = true
        let selectedAnnotations = self.mapSearchView.mapView.selectedAnnotations
        self.mapSearchView.mapView.deselectAnnotation(selectedAnnotations[0], animated: true)
    }
    
    @objc func customViewTapped() {
        let detailViewController = PlaceDetailViewController()
        detailViewController.place = currentPlace
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    @objc func cancelSearch() {
        //
        if self.tableView.isHidden && self.mapSearchView.optionsLabel.text == "" {
            self.tabBarController?.selectedIndex = 0
        }
        // cancel search but remain in the map view
        else if self.tableView.isHidden && self.mapSearchView.optionsLabel.text != "" {
            self.tableView.isHidden = true
            self.optionsTextField.resignFirstResponder()
            self.optionsTextField.text?.removeAll()
            //self.navigationItem.rightBarButtonItem?.isEnabled = false
            
        }
        else if self.mapSearchView.optionsLabel.text != "" {
            self.tableView.isHidden = true
            self.optionsTextField.text = "  Restaurants, bars, movies, etc"
            self.mapView.removeAnnotations(mapView.annotations)
        }
        else {
            self.tableView.isHidden = true
        }
        self.mapSearchView.customView.isHidden = true
        self.mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
        
    }
    @objc func performSearch() {
        searchByQuery()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchByQuery()
        return true
    }
    
    func searchByQuery() {
        tableView.isHidden = true
        optionsTextField.resignFirstResponder()
        let queryText = optionsTextField.text?.trimmingCharacters(in: .whitespaces)
        fetchPlaces(endpoint: .general, keyword: queryText)
    }
    
 
    
    
    
    override func displayAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No results found", message: "Sorry, there are no results in the specified location", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
    }
    
    @objc func labelTapped() {
        tableView.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //MARK: - MapView Methods
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        if let annotation = view.annotation as? CustomMapAnnotation {
            let indexPath = IndexPath(row: annotation.index!, section: 0)
            self.mapSearchView.customView.isHidden = false
          
            
            self.currentPlace = self.placesNearby[indexPath.row]
            DispatchQueue.main.async {
                if let currentPlace = self.currentPlace {
                    self.mapSearchView.nameLabel.text = currentPlace.name
                    self.mapSearchView.addressLabel.text = currentPlace.address
                    if let photos = currentPlace.photos  {
                        let reference = photos[0].reference
                        guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                            return
                        }
                        self.mapSearchView.imageView.fetchImage(url: url)
                    } else {
                        self.mapSearchView.imageView.image = #imageLiteral(resourceName: "no_image")
                    }
                }
            }
        } else {
            print("No annotation selected")
        }
    }
}
// MARK: - Extension Table View Methods
extension MapViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionsCellID) as! UITableViewCell
        let keys = Array(options.keys)
        let item = keys[indexPath.row]
        cell.textLabel?.text = item.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let keys = Array(options.keys)
        let optionKey = keys[index]
        
        guard let endpointSelected = options[optionKey] else {
            return
        }
        fetchPlaces(endpoint: endpointSelected, keyword: nil)
        mapSearchView.optionsLabel.text = ("  \(optionKey.capitalized)")
        tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height
        let cellHeight = height/CGFloat(options.count)
        return cellHeight
    }
}
