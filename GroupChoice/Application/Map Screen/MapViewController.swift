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

class MapViewController: BaseViewControllerWithLocation, UITextFieldDelegate, UISearchResultsUpdating, UISearchControllerDelegate,
                    UISearchBarDelegate {
    //var mainView: UIView!
    var currentPlace: Place?
    var mapSearchView: MapSearchView!
    var customView: CustomView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsTextField: UITextField!
    var searchController: UISearchController!
    var searchbar: UISearchBar!
    
    let options = ["restaurant": GooglePlacesAPI.Endpoint.restaurant,
                   "cafe": GooglePlacesAPI.Endpoint.cafe, "bar": GooglePlacesAPI.Endpoint.bar,
                   "gym": GooglePlacesAPI.Endpoint.gym,
                   "night club": GooglePlacesAPI.Endpoint.nightClub, "museum": GooglePlacesAPI.Endpoint.museum,
                   "amusement park": GooglePlacesAPI.Endpoint.amusementPark, "art gallery": GooglePlacesAPI.Endpoint.artGallery,
                   "park": GooglePlacesAPI.Endpoint.park, "bowling alley": GooglePlacesAPI.Endpoint.bowlingAlley]
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        if self.placesNearby.isEmpty {
            checkLocationServices()
        }
        setupNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        setupView()
        setupSearchBar()
        setupTableView()
        setupCustomViewGestures()
 
        mapView.delegate = self
 
    }
    
    // MARK: - Setup methods
    

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        searchbar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: optionsCellID)
        tableView.tableFooterView = UIView()
        //tableView.isScrollEnabled = false
    }
        
    
    func setupNavBar() {
        //self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Search"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(displayP3Red: 150/255, green: 211/255, blue: 255/255, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 150/255, green: 211/255, blue: 255/255, alpha: 1.0)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barStyle = .black
        }
    }
    func setupView() {
        let mapSearchView = MapSearchView()
        view.addSubview(mapSearchView)
        let customView = CustomView()
        self.customView = customView
        view.addSubview(customView)
        
        self.mapView = mapSearchView.mapView
        self.mapSearchView = mapSearchView
        
        self.mapView.frame = self.view.bounds
        tableView = mapSearchView.tableView
        
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        
        mapView.isUserInteractionEnabled = true
        mapSearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
            make.top.equalToSuperview().inset(navBarHeight)
        }
        
        customView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(mapSearchView.snp.bottom).offset(900)
        }
        view.bringSubviewToFront(customView)
    }
    func setupSearchBar() {
           searchController = UISearchController(searchResultsController: nil)
           self.navigationItem.searchController = searchController
           
           searchController.searchResultsUpdater = self
           searchController.hidesNavigationBarDuringPresentation = false
           searchController.searchBar.barTintColor = .white
           
           searchController.dimsBackgroundDuringPresentation = false
           searchController.delegate = self
           
           searchbar = searchController.searchBar
           searchController.searchBar.tintColor = .white
           searchbar.searchTextField.textColor = .white
           searchbar.showsCancelButton = true
           
           searchbar.becomeFirstResponder()
           searchbar.sizeToFit()
           
           searchbar.searchTextField.addTarget(self, action: #selector(searchTextFieldActivated), for: .editingDidBegin)
       }
    
    func setupCustomViewGestures() {
        let customViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customViewTapped))
        self.customView.addGestureRecognizer(customViewTapGestureRecognizer)
        
        let customSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(customViewSwiped))
        customSwipeGestureRecognizer.direction = .down
        self.customView.addGestureRecognizer(customSwipeGestureRecognizer)
    }
    
    @objc func customViewSwiped() {
        animateCustomView(toShow: false)
        let selectedAnnotations = self.mapSearchView.mapView.selectedAnnotations
        if !selectedAnnotations.isEmpty {
            self.mapSearchView.mapView.deselectAnnotation(selectedAnnotations[0], animated: true)
        }
    }
    
    @objc func customViewTapped() {
        let detailViewController = PlaceDetailViewController()
        detailViewController.place = currentPlace
        detailViewController.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Search Methods
    
    @objc func performSearch() {
        searchByQuery()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchByQuery() {
        tableView.isHidden = true
        optionsTextField.resignFirstResponder()
        let queryText = optionsTextField.text?.trimmingCharacters(in: .whitespaces)
        fetchPlaces(endpoint: .general, keyword: queryText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var keywordString = searchController.searchBar.text
        keywordString = keywordString!.trimmingCharacters(in: .whitespacesAndNewlines)
        fetchPlaces(endpoint: .general, keyword: keywordString)
        tableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text!.isEmpty && !tableView.isHidden {
            tableView.isHidden = true
            
        }
        if !mapView.selectedAnnotations.isEmpty {
            animateCustomView(toShow: false)
            mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
        }
        animateCustomView(toShow: false)
    }
  
    // MARK: - Helper methods
    
     override func displayAlert() {
        let alert = UIAlertController(title: "No results found", message: "Sorry, there are no results for your request", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             self.mapView.removeAnnotations(self.mapView.annotations)
     }

     @objc func searchTextFieldActivated() {
         self.tableView.isHidden = false
     }
    
    func animateCustomView(toShow show: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.customView.snp.updateConstraints { (make) in
                if show {
                    make.bottom.equalTo(self.mapSearchView.snp.bottom).inset(20)
                } else {
                    make.bottom.equalTo(self.mapSearchView.snp.bottom).offset(800)
                }
                
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - MapView Methods
    
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is MKUserLocation {
                return
            }
            if let annotation = view.annotation as? CustomMapAnnotation {
                let indexPath = IndexPath(row: annotation.index!, section: 0)
                animateCustomView(toShow: true)
                
                self.currentPlace = self.placesNearby[indexPath.row]
                DispatchQueue.main.async {
                    if let currentPlace = self.currentPlace {
                        self.customView.nameLabel.text = currentPlace.name
                        self.customView.addressLabel.text = currentPlace.address
                        if let photos = currentPlace.photos {
                            let reference = photos[0].reference
                            guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                                return
                            }
                            self.customView.imageView.fetchImage(url: url)
                        } else {
                            self.customView.imageView.image = #imageLiteral(resourceName: "no_image")
                        }
                    }
                }
            } else {
                print("No annotation selected")
            }
        }
}

// MARK: - Extension Table View Methods
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: optionsCellID, for: indexPath)
        
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
        searchbar.searchTextField.text = ("  \(optionKey.capitalized)")
        tableView.isHidden = true
        searchbar.searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
        (navigationController?.navigationBar.frame.height ?? 0.0)
        
        let height = self.view.frame.height - navBarHeight
        let cellHeight = height/CGFloat(options.count)
        return cellHeight
    }
}
