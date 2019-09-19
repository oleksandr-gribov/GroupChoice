//
//  GooglePlacesAPI.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/16/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation
import CoreLocation


// Enums for different end points
// func to construct the url

// restaurant, cafe, bar, gym, night club, museum, amusement park, art gallery, park, bowling alley
struct GooglePlacesAPI {
    
    static let apiKey = PlacesAPIKey
    static let basePath = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    enum Endpoint: String {
        case restaurant
        case cafe
        case bar
        case gym
        case nightClub = "night_club"
        case museum
        case amusementPark = "amusement_park"
        case artGallery = "art_gallery"
        case park
        case bowlingAlley = "bowling_alley"
        case general

    }
    
    static func makeUrl(endpoint: Endpoint, radius: Float, coordinate: CLLocationCoordinate2D) -> URL?  {
        let urlString = "\(basePath)location=\(coordinate.latitude),\(coordinate.longitude)&type=\(endpoint.rawValue)&radius=\(radius)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        return url
    }
    
    static func genericURL(coordinate: CLLocationCoordinate2D) -> URL?  {
        let urlString = "\(basePath)location=\(coordinate.latitude),\(coordinate.longitude)&radius=500&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        return url
    }
    
    static func imageURL(reference: String) -> URL? {
        let urlString =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        return url
    }
}




