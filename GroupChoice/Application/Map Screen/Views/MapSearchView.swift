//
//  MapView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/9/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit

class MapSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(tableView)
        addSubview(mapView)
     
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bringSubviewToFront(tableView)
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    let locationSearchBar: UISearchBar = {
        let scb = UISearchBar()
        scb.placeholder = "Current Location"
        return scb
    }()
    let mapView: MKMapView = {
        let mp = MKMapView()
        
        return mp
    }()
    
}
