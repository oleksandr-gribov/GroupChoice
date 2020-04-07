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
        self.mapView.removeAnnotations(mapView.annotations)
        for place in placesNearby {
            let placePin = CustomMapAnnotation()
            let indexOfPlace = placesNearby.firstIndex(of: place)
            placePin.index = indexOfPlace
            
            let placeCoordinate = CLLocationCoordinate2D(latitude: Double(place.geometry.location.latitude), longitude: Double(place.geometry.location.longitude))
            
            placePin.coordinate = placeCoordinate
            placePin.title = place.name
            
            self.mapView.addAnnotation(placePin)
        }
    }
}
