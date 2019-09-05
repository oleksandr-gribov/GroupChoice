//
//  DownloadsViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MKMapViewDelegate{
    
    var searchView: SearchView!
    let locationManager = CLLocationManager()
    let regionInMeters : Double  = 1000
    let placesCellId = "placesCellId"
    var placesNearby = [Place]()
    var currentLocation: CLLocationCoordinate2D?
    var mapView : MKMapView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white 
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(PlacesCell.self, forCellWithReuseIdentifier: placesCellId)
        
        setupNavBar()
        searchView = SearchView()
        mapView = searchView.mapView
        mapView.delegate = self
        setupView()
        checkLocationServices()

    }
 
    
    // MARK: - Fetching data
    func fetchPlaces() {
        self.placesNearby.removeAll()
        guard let currentLocation = currentLocation else {
            return
        }
        guard let url = GooglePlacesAPI.genericURL(coordinate: currentLocation) else {
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
                self.collectionView.reloadData()
                self.placePins()
            }
        }
    }
    
    func placePins() {
        for place in placesNearby {
            let placePin = MKPointAnnotation()
            let placeCoordinate = CLLocationCoordinate2D(latitude: Double(place.geometry.location.latitude), longitude: Double(place.geometry.location.longitude))
            
            placePin.coordinate = placeCoordinate
            placePin.title = place.name

            
            searchView.mapView.addAnnotation(placePin)
//            print("Id: \(place.id), lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
        }
    }
   
    
    // MARK: - CollectionView methods
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if placesNearby.count < 20 {
            return placesNearby.count
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placesCellId, for: indexPath) as! PlacesCell
        if placesNearby.count > 0 {
            let place = placesNearby[indexPath.row]
            
            cell.nameLabel.text = place.name
            if let addressText = place.address {
                cell.addressLabel.text = place.address
            } else {
                cell.addressLabel.text = "Address not available"
            }
            
            if let rating = place.rating {
                cell.ratingLabel.text = String(rating)
            }
            if let photos = place.photos  {
                let reference = photos[0].reference
                guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                    return cell
                }
                cell.imageView.fetchImage(url: url)
            } else {
                cell.imageView.image = #imageLiteral(resourceName: "no_image")
            }
            let userLocation = CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
            
            let placeLocation = CLLocation(latitude: CLLocationDegrees(place.geometry.location.latitude), longitude: CLLocationDegrees(place.geometry.location.longitude))
            
            let distanceTo = userLocation.distance(from: placeLocation)
            let distanceStr = NSString(format: "%.f", distanceTo)
            cell.distanceLabel.text = "\(distanceStr) m"
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2.5)-16, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = placesNearby[indexPath.row]
        let detailVC = PlaceDetailViewController()
        detailVC.place = place
        detailVC.userLocation = currentLocation 
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    

    // MARK: - View set up
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
            make.right.equalToSuperview()
            make.height.equalTo(250)
        }
        let mapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapGestureRecognizer.numberOfTapsRequired = 2
        searchView.mapView.addGestureRecognizer(mapGestureRecognizer)
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        view.bringSubviewToFront(collectionView)
    }
    
    @objc func mapTapped() {
        let tbvc = self.tabBarController as! TabBarViewController
        tbvc.location = "london"
        navigationController?.tabBarController?.selectedIndex = 3
       
    }
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Discover"
        
        let photoView : UIView = {
            let pv = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
            pv.layer.cornerRadius = 23
            pv.backgroundColor = .black
           
            return pv
        }()

        photoView.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: photoView)
        
    }
    
    
    // MARK: - MapKit methods
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert to user to turn it on
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            searchView.mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            fetchPlaces()
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
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            currentLocation = location
            print ("current location is: \(currentLocation)")
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            searchView.mapView.setRegion(region, animated: true)
        } else {
            print("no center view location")
        }
    }
}


// MARK: - Extensions
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print (currentLocation)
        if currentLocation == nil  {
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        let userLocation = CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
        
        let distanceTo = userLocation.distance(from: location)
        print (distanceTo)
        if distanceTo > 500  {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            searchView.mapView.setRegion(region, animated: true)
            let newUserLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            currentLocation = newUserLocation
            fetchPlaces()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


