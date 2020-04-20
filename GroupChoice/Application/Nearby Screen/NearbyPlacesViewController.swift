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

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(PlacesCell.self, forCellWithReuseIdentifier: placesCellId)
        self.collectionView.allowsSelection = true
        setupNavBar()
        searchView = NearbyView()
        mapView = searchView.mapView
        mapView.delegate = self 
        setupView()
        
        searchView.redoSearchAreaButton.addTarget(self, action: #selector(redoSearchReginButtonTapped), for: .touchUpInside)

    }
    
    @objc func redoSearchReginButtonTapped() {
        print("redo search button tapped")
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
            fetchPlaces(endpoint: nil, keyword: nil)
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Discover"
        
    }
    func animateRedoSearchButton() {
        UIView.animate(withDuration: 0.5) {
            self.searchView.redoSearchAreaButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.searchView.topblur.snp.bottom).inset(170)
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
        self.fetchPlaces(endpoint: nil, keyword: nil)
        print("number of places fetched in the child VC \(self.placesNearby.count)")
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        // check that the region changed substantially by comapring the center points
        let centerDelta = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        let delta = centerDelta.distance(from: CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
        if !placesNearby.isEmpty {
            if delta > 850 {
                
                       //animateRedoSearchButton()
                   }
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
