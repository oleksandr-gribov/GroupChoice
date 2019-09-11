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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        setupView()
        setupNavBar()
        
    }
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    func setupView() {
        
        
        detailView = PlaceDetailView()
        view.addSubview(detailView)
        detailView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
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
       
        
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        tapgestureRecognizer.numberOfTapsRequired = 1
        
        detailView.mapView.addGestureRecognizer(tapgestureRecognizer)

        centerMapOnLocation()
    }
    @objc func testingClicked() {
        print ("Button clicked")
    }
    @objc func mapTapped() {
        print("map tapped")
        let nav = self.tabBarController?.viewControllers![3] as! UINavigationController
        let vc = nav.topViewController as! MapViewController
        vc.currentUserLocation = placeCoordinate
        vc.place = place
        navigationController?.tabBarController?.selectedIndex = 3
    }
    
    func typesDescription() -> String {
        let types = place.types
        var index = types.count
        if index == 0  {
            return "Point of Interest"
        } else {
            var typesString = ""
            for i in 0..<types.count {
                if types[i] == "point_of_interest" {
                    index = i
                }
            }
            for i in 0..<index {
                let curr = types[i]
                let formatted = curr.replacingOccurrences(of: "_", with: " ")
                if i == index - 1 {
                    typesString += formatted.capitalized
                } else {
                    typesString += "\(formatted.capitalized), "
                }
            }
            return typesString
        }
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
    
    func centerMapOnLocation() {
        if placeCoordinate != nil {
            
        }
        let region = MKCoordinateRegion.init(center: placeCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        detailView.mapView.setRegion(region, animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
