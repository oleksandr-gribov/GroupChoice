//
//  Place.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/16/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit

struct Place: Codable, Hashable {
    var id: String
    var name: String
    var rating: Double?
    var price: Int?
    var address: String?
    var photos: [Photo]?
    var types: [String]
    var photo: UIImage?
    var geometry: Geometry
    var hours: OpenHours?
    
    enum CodingKeys: String, CodingKey {
        case name, rating, photos, types, geometry
        case price = "price_level"
        case address = "vicinity"
        case hours = "opening_hours"
        case id = "place_id"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
struct Geometry: Codable {
    
    var location: Coordinate
    
    struct Coordinate: Codable {
        var latitude: Float
        var longitude: Float
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}

struct Photo: Codable {
    var reference: String
    
    enum CodingKeys: String, CodingKey {
        case reference = "photo_reference"
    }
}
struct OpenHours: Codable {
    var openNow: Bool?  
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
// Wrapper struct to match the API JSON structure
struct Response: Codable {
    var results: [Place]
}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
        }
    }  
