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

class MapViewController: UIViewController {
    
    var mapView : MKMapView!
    var mainView: UIView!
    var coordinate: CLLocationCoordinate2D?
    var place: Place?
    
    let locationManager = CLLocationManager()
    
  
    override func viewWillAppear(_ animated: Bool) {
        let tbvc = self.tabBarController as! TabBarViewController
        
        centerMapOnLocation(center: coordinate)
        let placePin = MKPointAnnotation()
        if let coordinate = coordinate {
            print (coordinate)
            placePin.coordinate = coordinate
            placePin.title = place?.name
            mapView.addAnnotation(placePin)
        }
       
    }
   
    
    func centerMapOnLocation(center: CLLocationCoordinate2D?) {
        
        if let center = center {
             let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        } else {
            if let location = locationManager.location?.coordinate {
                 let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 2000)
                mapView.setRegion(region, animated: true)
            }
        
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        mainView = view
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        mapView = MKMapView(frame: view.bounds)
        self.mapView.frame = self.view.bounds
        
        view.addSubview(mapView)
        
    
        
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
