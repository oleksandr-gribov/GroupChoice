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

class NearbyPlacesViewController: BaseViewControllerWithLocation, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var searchView: NearbyView!
    let placesCellId = "placesCellId"
    public static var userLocation: CLLocationCoordinate2D?
    private var mapChangedFromUserInteraction = false
    var mapViewRegion: MKCoordinateRegion!
    var currentVisibleRegion: MKCoordinateRegion!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
          overrideUserInterfaceStyle = .light
        }

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(PlacesCell.self, forCellWithReuseIdentifier: placesCellId)
        self.collectionView.allowsSelection = true
        setupNavBar()
        searchView = NearbyView()
        mapView = searchView.mapView
        mapView.delegate = self
        setupView()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Discover", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        searchView.redoSearchAreaButton.addTarget(self, action: #selector(redoSearchReginButtonTapped), for: .touchUpInside)
        
        mapViewRegion = self.mapView.region
        
        print("visible height is \(self.mapView.visibleMapRect.height/2)")
      

    }
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0] as UIView
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    @objc func redoSearchReginButtonTapped() {
        let radius = (currentVisibleRegion.span.latitudeDelta - mapViewRegion.span.latitudeDelta) / 2
        var radiusForUrl : Double?
        if radius > 500 {
            radiusForUrl = abs(radius)
        } else {
            radiusForUrl = 500
        }
        guard let url = GooglePlacesAPI.makeUrl(endpoint: .general, radius: Float(radiusForUrl!), coordinate: currentVisibleRegion.center, keyword: nil) else {
            print("Couldnt construct url")
            return
        }
        print("URL from new region is: \(url)")
        fetchPlaces(endpoint: .general, keyword: "", suppliedUrl: url)
        animateRedoSearchButton(show: false)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if placesNearby.isEmpty {
            checkLocationServices()
            
        }
        collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if placesNearby.isEmpty {
            fetchPlaces(endpoint: nil, keyword: nil, suppliedUrl: nil)
            NearbyPlacesViewController.userLocation = self.currentLocation
        }
    }
 
    override func updateCollectionComponents() {
        self.collectionView.reloadData()
    }

    // MARK: - CollectionView methods
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    
    // MARK: - View set up
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            //make.bottom.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().inset(tabBarHeight!+10)
            make.right.equalToSuperview()
            make.height.equalTo(250)
        }
       
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        view.bringSubviewToFront(collectionView)
    }
    
    fileprivate func setupNavBar() {
        
        
        self.navigationItem.title = "Discover"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33), NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.configureWithTransparentBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            
            
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
            self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        }
        
        
    }
  
    func animateRedoSearchButton( show: Bool) {
        UIView.animate(withDuration: 0.7) {
            if show {
                self.searchView.redoSearchAreaButton.alpha = 1.0
            } else {
                self.searchView.redoSearchAreaButton.alpha = 0
            }
        }
    }
    
    // MARK: - MapKit methods
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomMapAnnotation {
            let indexPath = IndexPath(row: annotation.index!, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        } else {
            print("No annotation selected")
        }
    }
    override func recenterMap(location: CLLocation) {
        super.recenterMap(location: location)
        self.fetchPlaces(endpoint: nil, keyword: nil, suppliedUrl: nil)
    }
    fileprivate func calculateAreaChanged(_ mapView: MKMapView) {
        // check that the region changed substantially by comapring the center points
        let newCenter = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        let centerPointDelta = newCenter.distance(from: CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
        let newRegion = mapView.region
        
        let regionLatDelta = max(newRegion.span.latitudeDelta, mapViewRegion.span.latitudeDelta)
            / min(newRegion.span.latitudeDelta, mapViewRegion.span.latitudeDelta)
        
        let regionLongDelta = max(newRegion.span.longitudeDelta, mapViewRegion.span.longitudeDelta)
            / min(newRegion.span.longitudeDelta, mapViewRegion.span.longitudeDelta)
        
        if !placesNearby.isEmpty {
            if (regionLongDelta > 11000 ||  regionLatDelta > 11000) || centerPointDelta > 1500 {
                animateRedoSearchButton(show: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentVisibleRegion = mapView.region
        if mapChangedFromUserInteraction {
            calculateAreaChanged(mapView)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.mapChangedFromUserInteraction =  mapViewRegionDidChangeFromUserInteraction()
        if mapChangedFromUserInteraction {
            calculateAreaChanged(mapView)
        }
    }
}

extension NearbyPlacesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !placesNearby.isEmpty {
            return placesNearby.count
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // swiftlint:disable force_cast
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placesCellId, for: indexPath) as! PlacesCell
            if !placesNearby.isEmpty {
                let place = placesNearby[indexPath.row]
                
                cell.setupCellData(place: place)

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
        print("index path of the collection view cell selected: \(indexPath)")
        let place = placesNearby[indexPath.row]
        let detailVC = PlaceDetailViewController()
        detailVC.place = place
        detailVC.userLocation = currentLocation
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
