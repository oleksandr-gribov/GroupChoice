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

class MapViewController: BaseViewControllerWithLocation, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

  
    
    var mainView: UIView!
    var place: Place?
    var mapSearchView: MapSearchView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsTextField: UITextField!
   
   
    var options = ["restaurant":GooglePlacesAPI.Endpoint.restaurant, "cafe":GooglePlacesAPI.Endpoint.cafe, "bar":GooglePlacesAPI.Endpoint.bar, "gym":GooglePlacesAPI.Endpoint.gym, "night club": GooglePlacesAPI.Endpoint.nightClub, "museum":GooglePlacesAPI.Endpoint.museum, "amusement park": GooglePlacesAPI.Endpoint.amusementPark, "art gallery": GooglePlacesAPI.Endpoint.artGallery, "park": GooglePlacesAPI.Endpoint.park, "bowling alley": GooglePlacesAPI.Endpoint.bowlingAlley]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
        cancelBarButton.tintColor = .white
         let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(performSearch))
        searchButton.tintColor = .white
        
        
    
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 150/255, green: 211/255, blue: 255/255, alpha: 1.0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: optionsCellID)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        optionsTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        optionsTextField.isUserInteractionEnabled = true
        optionsTextField.addGestureRecognizer(tapGestureRecognizer)
       
    }
    @objc func cancelSearch() {
        if self.tableView.isHidden {
            self.tabBarController?.selectedIndex = 0
        } else {
            self.tableView.isHidden = true
            self.optionsTextField.resignFirstResponder()
        }
        
    }
    @objc func performSearch() {
        searchByQuery()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        
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
   
    fileprivate func setupView() {
        
        mapSearchView = MapSearchView()
        view.addSubview(mapSearchView)
        mapView = mapSearchView.mapView
        self.mapView.frame = self.view.bounds
       
        mapSearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
        }
        optionsTextField = mapSearchView.optionsLabel
        tableView = mapSearchView.tableView
     
        mapView.isUserInteractionEnabled = true
    }
    
    // MARK: - Table View Methods
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
    
    override func displayAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No results found", message: "Sorry, there are no results in the specified location", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func labelTapped() {
        tableView.isHidden = false
    }
    
    //MARK: - MapView Methods
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomMapAnnotation {
            let indexPath = IndexPath(row: annotation.index!, section: 0)
            print("Annotation selected at \(indexPath)")
        } else {
            print("No annotation selected")
        }
    }
}
