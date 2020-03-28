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

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate, PlaceMapPins {

    var mapView: MKMapView!
    
    var mainView: UIView!
    var currentUserLocation: CLLocationCoordinate2D?
    var place: Place?
    var mapSearchView: MapSearchView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsTextField: UITextField!
    let locationManager = CLLocationManager()
    var placesNearby = [Place]()
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
        self.tableView.isHidden = true
        self.optionsTextField.resignFirstResponder()
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
        mapSearchView.optionsLabel.text = optionKey.capitalized
        tableView.isHidden = true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height
        let cellHeight = height/CGFloat(options.count)
        return cellHeight
    }
    // MARK: - Fetching data
    func fetchPlaces(endpoint: GooglePlacesAPI.Endpoint, keyword: String?) {
        self.placesNearby.removeAll()
        guard let currentLocation = currentUserLocation else {
            print ("no location in fetchPlaces()")
            return
        }
        
        guard let url = GooglePlacesAPI.makeUrl(endpoint: endpoint, radius: 2000, coordinate: currentLocation, keyword: keyword) else {
                print("couldnt construct url")
                return
        }

        print(url)
        Network.fetchGenericData(url: url) { (response: Response) in
            if response.results.count != 0 {
                for place in response.results {
                    if !(self.placesNearby.contains(place)) {
                        self.placesNearby.append(place)
                    }
                }
                DispatchQueue.main.async {
                    self.placePins()
                }
            } else {
                // display an alert
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No results found", message: "Sorry, there are no results in the specified location", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
   
    // MARK: - Location methods
    func centerMapOnLocation(center: CLLocationCoordinate2D?) {
        
        if let center = center {
             let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        } else {
            if let location = locationManager.location?.coordinate {
                 let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
                mapView.setRegion(region, animated: true)
                currentUserLocation = location
                
            }
        
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert to user to turn it on
        }
    }
   
    
    @objc func labelTapped() {
        tableView.isHidden = false
    }
    
    //MARK: - MapView Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "identifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomMapAnnotation {
            let indexPath = IndexPath(row: annotation.index!, section: 0)
            print("index path of the selected annotation is \(indexPath)")
            let placeSelected = self.placesNearby[indexPath.row]
            print("Place Selected on the map is \(placeSelected.name)")
        } else {
            print("couldn't select pin")
        }
    }
  
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            // Show an alert letting them know
            break
        case .authorizedAlways:
            break
        }
    }
    
}

// MARK: - Extensions
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print ("no location in didUpdateLocations")
            return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
        currentUserLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
  
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            print ("now authorized")
            
        }
        if status == .denied {
            let alert = UIAlertController(title: "Location disabled", message: "We need your location to show you nearby places", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enable Location Services", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
}
