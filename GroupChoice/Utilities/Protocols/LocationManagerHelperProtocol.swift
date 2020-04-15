//
//  LocationManagerProtocol.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 3/29/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation
import MapKit

protocol LocationManagerHelperProtocol {
    var locationManager: CLLocationManager { get }
    var currentUserLocation: CLLocationCoordinate2D { get }
}
