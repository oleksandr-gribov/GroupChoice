//
//  Place.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/16/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit


struct Place: Codable {
    var name: String
    var rating: Double?
    var price: Int?
    var address: String
    var photos: [Photo]?
    var types: [String]
    var photo: UIImage?
    
    
    enum CodingKeys: String, CodingKey {
        case name, rating, photos, types
        case price = "price_level"
        case address = "vicinity"
    }
}

struct Photo: Codable {
    var reference: String
    
    enum CodingKeys: String, CodingKey {
        case reference = "photo_reference"
    }
}
// Wrapper struct to match the API JSON structure
struct Response : Codable {
    var results: [Place]
}
