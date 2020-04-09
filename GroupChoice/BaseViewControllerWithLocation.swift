//
//  BaseViewControllerWithLocation.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 3/29/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class BaseViewControllerWithLocation: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate, PlaceMapPins {
    
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            NearbyPlacesViewController.userLocation = self.currentLocation
        }
    }
    let regionInMeters: Double = 1000
    var placesNearby = [Place]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Location Methods
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert to user to turn it on
            let alert = UIAlertController(title: "Location disabled", message: "Location access is restricted. Please enable GPS in the Settings app under Privacy, Location Services.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            centerViewOnUserLocation()
            fetchPlaces(endpoint: nil, keyword: nil)
            break
        case .denied:
            let alert = UIAlertController(title: "Location disabled", message: "We need your location to show nearby places", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enable Location Services", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            }))
            
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
                  let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                  self.mapView.setRegion(region, animated: true)
              } else {
                  print("no center view location")
              }
          }
    // MARK: - Fetching Data
    func fetchPlaces(endpoint: GooglePlacesAPI.Endpoint?, keyword:String?) {
        self.placesNearby.removeAll()
        guard let currentLocation = currentLocation else {
            print ("no location in fetch places")
            return
        }
        guard let url = GooglePlacesAPI.makeUrl(endpoint: endpoint ?? GooglePlacesAPI.Endpoint.general, radius: 500, coordinate: currentLocation, keyword: keyword ?? nil) else {
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
                print ("number of places fetched in fetchPlaces is \(self.placesNearby.count)")
                DispatchQueue.main.async {
                    print ("number of places fetched in fetchPlaces is \(self.placesNearby.count)")
                    self.placePins()
                    self.updateCollectionComponents()
                }
            }
            } else {
                self.displayAlert()
            }
              }
    }
    
    
    func updateCollectionComponents() {
        
    }
    func displayAlert() {
        
    }
    
    

// MARK: - Location Manager Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print ("no new location in didupdatalocations")
            return }
        if currentLocation == nil {
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            recenterMap(location: CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude))
        } else {
            let newUserLocation = CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
            
            let distanceTo = newUserLocation.distance(from: location)
            if distanceTo > 500 {
                recenterMap(location: newUserLocation)
            }
        }
        
    }
    func recenterMap(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        self.mapView.setRegion(region, animated: true)
        centerViewOnUserLocation()
            
    }
    func centerMapOnLocation(center: CLLocationCoordinate2D?) {
        
        if let center = center {
             let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        } else {
            if let location = locationManager.location?.coordinate {
                 let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
                mapView.setRegion(region, animated: true)
                currentLocation = location
                
            }
        
        }
    }

   
}
