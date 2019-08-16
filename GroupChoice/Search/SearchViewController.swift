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

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var searchView: SearchView!
    let locationManager = CLLocationManager()
    let regionInMeters : Double  = 10000
    let placesCellId = "placesCellId"
    var placesNearby = [Place]()
    var currentLocation: CLLocationCoordinate2D?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(PlacesCell.self, forCellWithReuseIdentifier: placesCellId)
        searchView = SearchView()
        setupNavBar()
        setupView()
        checkLocationServices()
        
        
    }
    
    // MARK: - Fetching data
    func fetchPlaces() {
        guard let currentLocation = currentLocation else {
            print("no current location available")
            return
        }
        guard let url = GooglePlacesAPI.genericURL(coordinate: currentLocation) else {
            print("couldnt construct url")
            return
        }
        Network.fetchGenericData(url: url) { (response: Response) in
            for place in response.results {
                self.placesNearby.append(place)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.fetchImages()
        }
    }
    func fetchImages() {
        for i in 0..<placesNearby.count {
            guard let photos = placesNearby[i].photos else {
                return
            }
            let reference = photos[0].reference
            
            guard let url = GooglePlacesAPI.imageURL(reference: reference) else  {
                print ("Couldnt make image url")
                return
            }
            let photo = Network.fetchImage(url: url)
            print(photo)
            placesNearby[i].photo = photo
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
            cell.addressLabel.text = place.address
            if let rating = place.rating {
                cell.ratingLabel.text = String(rating)
            }
            //cell.imageView.image = #imageLiteral(resourceName: "Background")
            guard let photos = place.photos else {
                return cell
            }
            let reference = photos[0].reference
            
            guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                return cell
            }
            let data = NSData(contentsOf: url)
            cell.imageView.image = UIImage(data: data as! Data)
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2.5)-16, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        var place = placesNearby[indexPath.row]
//        guard let photos = place.photos else {
//            return
//        }
//        let reference = photos[0].reference
//
//        guard let url = GooglePlacesAPI.imageURL(reference: reference) else  {
//            print ("Couldnt make image url")
//            return
//        }
//        let photo = Network.fetchImage(url: url)
//        placesNearby[indexPath.row].photo = photo
//        print (photo)
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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: 2000)
            searchView.mapView.setRegion(region, animated: true)
        }
    }
}


// MARK: - Extensions
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        searchView.mapView.setRegion(region, animated: true)
       // fetchPlaces()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


