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
    // MARK: - CollectionView methods
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placesCellId, for: indexPath) as! PlacesCell
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2.5)-16, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: 10000)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


