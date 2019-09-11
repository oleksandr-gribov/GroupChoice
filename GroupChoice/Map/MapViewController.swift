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
    
    var options = ["restaurant":GooglePlacesAPI.Endpoint.restaurant, "cafe":GooglePlacesAPI.Endpoint.cafe, "bar":GooglePlacesAPI.Endpoint.bar, "gym":GooglePlacesAPI.Endpoint.gym, "night club": GooglePlacesAPI.Endpoint.nightClub, "museum":GooglePlacesAPI.Endpoint.museum, "amusement park": GooglePlacesAPI.Endpoint.amusementPark, "art gallery": GooglePlacesAPI.Endpoint.artGallery, "park": GooglePlacesAPI.Endpoint.park, "bowling alley": GooglePlacesAPI.Endpoint.bowlingAlley]

    var mapView : MKMapView!
    var mainView: UIView!
    var currentUserLocation: CLLocationCoordinate2D?
    var place: Place?
    var mapSearchView: MapSearchView!
    var tableView: UITableView!
    let optionsCellID = "optionsCell"
    var optionsLabel: UILabel!
    let locationManager = CLLocationManager()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    fileprivate func setupView() {
        mapView = MKMapView(frame: view.bounds)
        self.mapView.frame = self.view.bounds
        view.addSubview(mapView)
        mapSearchView = MapSearchView()
        view.addSubview(mapSearchView)
        mapSearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
        }
        view.bringSubviewToFront(mapSearchView)
        
        optionsLabel = mapSearchView.optionsLabel
        tableView = mapSearchView.tableView
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
        let optionSelected = options[optionKey]
        mapSearchView.optionsLabel.text = optionKey.capitalized
        tableView.isHidden = true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height
        let cellHeight = height/CGFloat(options.count)
        return cellHeight
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
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
