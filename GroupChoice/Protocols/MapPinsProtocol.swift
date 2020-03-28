//
//  MapPinsProtocol.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 3/29/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation
import MapKit

protocol PlaceMapPins {
    var mapView: MKMapView! { get }
    var placesNearby : [Place] { get }
    
    func placePins()
}

extension PlaceMapPins {
    func placePins() {
        let mapAnnotations = mapView.annotations
        mapView.removeAnnotations(mapAnnotations)
        for place in placesNearby {
            let placePin = MKPointAnnotation()
            let placeCoordinate = CLLocationCoordinate2D(latitude: Double(place.geometry.location.latitude), longitude: Double(place.geometry.location.longitude))
            
            placePin.coordinate = placeCoordinate
            placePin.title = place.name
            
            
            self.mapView.addAnnotation(placePin)
        }
    }
}
