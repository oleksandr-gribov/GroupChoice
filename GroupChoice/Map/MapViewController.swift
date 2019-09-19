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

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   

    var mapView : MKMapView!
    var mainView: UIView!
    var currentUserLocation: CLLocationCoordinate2D?
    var place: Place?
    var mapSearchView: MapSearchView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsLabel: UILabel!
    let locationManager = CLLocationManager()
    var placesNearby = [Place]()
    var options = ["restaurant":GooglePlacesAPI.Endpoint.restaurant, "cafe":GooglePlacesAPI.Endpoint.cafe, "bar":GooglePlacesAPI.Endpoint.bar, "gym":GooglePlacesAPI.Endpoint.gym, "night club": GooglePlacesAPI.Endpoint.nightClub, "museum":GooglePlacesAPI.Endpoint.museum, "amusement park": GooglePlacesAPI.Endpoint.amusementPark, "art gallery": GooglePlacesAPI.Endpoint.artGallery, "park": GooglePlacesAPI.Endpoint.park, "bowling alley": GooglePlacesAPI.Endpoint.bowlingAlley]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        checkLocationServices()
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: optionsCellID)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        optionsLabel.isUserInteractionEnabled = true
        optionsLabel.addGestureRecognizer(tapGestureRecognizer)
       
    }
    
    
    fileprivate func setupView() {
        
        mapSearchView = MapSearchView()
        view.addSubview(mapSearchView)
        mapView = mapSearchView.mapView
        self.mapView.frame = self.view.bounds
       
        mapSearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
        }
        optionsLabel = mapSearchView.optionsLabel
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
        fetchPlaces(endpoint: endpointSelected)
        mapSearchView.optionsLabel.text = optionKey.capitalized
        tableView.isHidden = true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height
        let cellHeight = height/CGFloat(options.count)
        return cellHeight
    }
    // MARK: - Fetching data
    func fetchPlaces(endpoint: GooglePlacesAPI.Endpoint) {
        self.placesNearby.removeAll()
        guard let currentLocation = currentUserLocation else {
            print ("no location in fetchPlaces()")
            return
        }
        guard let url = GooglePlacesAPI.makeUrl(endpoint: endpoint, radius: 500, coordinate: currentLocation) else {
            print("couldnt construct url")
            return
        }
        print(url)
        Network.fetchGenericData(url: url) { (response: Response) in
            for place in response.results {
                if !(self.placesNearby.contains(place)) {
                    self.placesNearby.append(place)
                }
            }
            DispatchQueue.main.async {
                self.placePins()
            }
        }
        
    }
    
    func placePins() {
        let mapAnnotations = mapView.annotations
        mapView.removeAnnotations(mapAnnotations)
        for place in placesNearby {
            let placePin = MKPointAnnotation()
            let placeCoordinate = CLLocationCoordinate2D(latitude: Double(place.geometry.location.latitude), longitude: Double(place.geometry.location.longitude))
            
            placePin.coordinate = placeCoordinate
            placePin.title = place.name
            
            
            self.mapView.addAnnotation(placePin)
        }
    }
   
    // MARK: - Location methods
    func centerMapOnLocation(center: CLLocationCoordinate2D?) {
        
        if let center = center {
             let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        } else {
            if let location = locationManager.location?.coordinate {
                 let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 2000)
                mapView.setRegion(region, animated: true)
                currentUserLocation = location
                print ("current user location is: \(currentUserLocation)")
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
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        currentUserLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
  
        print ("current location in MapVC is: \(currentUserLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
