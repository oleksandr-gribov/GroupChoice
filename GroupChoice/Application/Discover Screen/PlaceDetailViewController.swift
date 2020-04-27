//
//  PlaceDetailViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/19/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController, MKMapViewDelegate {
    var detailView: PlaceDetailView!
    var place: Place!
    var placeCoordinate: CLLocationCoordinate2D!
    var userLocation: CLLocationCoordinate2D!
    
    // MARK: - View life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        gestureRecognizer.direction = .right
        
        
        self.detailView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if let vcs =  self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            if previousVC.isKind(of: NearbyPlacesViewController.self) {
                self.navigationController?.navigationBar.barStyle = .black
                self.navigationController?.navigationBar.isTranslucent = true
            }
        }
    }

    
    // MARK: - Setup Methods
    func setupNavBar() {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.configureWithTransparentBackground()
            appearance.shadowImage = UIImage()
            
            let button = UIBarButtonItemAppearance(style: .plain)
            
            button.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.buttonAppearance = button
            
            appearance.shadowColor = .clear
            
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.barStyle = .black
        }
    }
    
    func setupView() {
        detailView = PlaceDetailView()
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            if tabBarController != nil {
                make.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.size.height)!)
            } else {
                make.bottom.equalToSuperview()
            }
            make.right.equalToSuperview()
        }
        
        detailView.nameLabel.text = place.name
        detailView.addressLabel.text = place.address
        detailView.descriptionTypes.text = typesDescription()
        if let hours = place.hours {
            if hours.openNow == true {
                detailView.openNow.text = "Open"
            } else {
                detailView.openNow.text = "Closed"
                detailView.openNow.textColor = .red
            }
        }
        guard let photos = place.photos else {
            return
        }
        let reference = photos[0].reference
        
        guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
            return
        }
        
        detailView.imageView.fetchImage(url: url)
        placeCoordinate = CLLocationCoordinate2D(latitude: Double(place.geometry.location.latitude), longitude: Double(place.geometry.location.longitude))
        
        let placePin = MKPointAnnotation()
        
        placePin.coordinate = placeCoordinate
        detailView.mapView.addAnnotation(placePin)
        detailView.mapView.isUserInteractionEnabled = true
        
        centerMapOnLocation()
    }
   
    // MARK: - Helper methods
    func typesDescription() -> String {
        let types = place.types
        var index = types.count
        if index == 0 {
            return "Point of Interest"
        } else {
            var typesString = ""
            for num in 0..<types.count {
                if types[num] == "point_of_interest" {
                    index = num
                }
            }
            for num in 0..<index {
                let curr = types[num]
                let formatted = curr.replacingOccurrences(of: "_", with: " ")
                if num == index - 1 {
                    typesString += formatted.capitalized
                } else {
                    typesString += "\(formatted.capitalized), "
                }
            }
            return typesString
        }
    }
    
    @objc func testingClicked() {
           print("Button clicked")
       }
    
    
    @objc func swipeRight() {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Map and Location methods
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
    
    func centerMapOnLocation() {
        if placeCoordinate != nil {
            
        }
        let region = MKCoordinateRegion.init(center: placeCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        detailView.mapView.setRegion(region, animated: true)
    }
    
}
