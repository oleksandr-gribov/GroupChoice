//
//  SearchView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/15/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit


class SearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let topblur: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "top blur")
        return iv
    }()
    
    
    let bottomBlur: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bottom blur")
        return iv
    }()
    
    let mapView: MKMapView = {
        let mp = MKMapView()
        
        return mp
    }()
    
    
    func setup() {
        addSubview(topblur)
        addSubview(bottomBlur)
        addSubview(mapView)
        topblur.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        bottomBlur.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        bringSubviewToFront(topblur)
        bringSubviewToFront(bottomBlur)
       
    }
}
