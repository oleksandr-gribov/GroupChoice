//
//  BookmarksViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapview : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        self.navigationItem.title = "Map"
        mapview = MKMapView(frame: view.bounds)
        self.mapview.frame = self.view.bounds
        
        view.addSubview(mapview)
        
    }

}
