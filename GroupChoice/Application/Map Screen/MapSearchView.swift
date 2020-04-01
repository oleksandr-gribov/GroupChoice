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
        super.init(frame:frame)
        
        addSubview(topSquare)
        
        topSquare.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        topSquare.addSubview(optionsLabel)
        
        optionsLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topSquare.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addSubview(mapView)
        bringSubviewToFront(topSquare)
        bringSubviewToFront(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topSquare: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "MapRect")
        iv.isUserInteractionEnabled = true 
        return iv 
    }()
    
    let optionsLabel: UITextField = {
        let lbl = UITextField()
        lbl.placeholder = "  Restaurants, bars, movies, etc"
        lbl.backgroundColor = .white
        lbl.isUserInteractionEnabled = true
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        lbl.keyboardType = UIKeyboardType.webSearch
        return lbl
    }()
    
    let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Current Location"
        lbl.textColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        lbl.backgroundColor = .white
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
       
        return lbl
    }()
    let tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    let mapView: MKMapView = {
        let mp = MKMapView()
        return mp
    }()
  
    
}
