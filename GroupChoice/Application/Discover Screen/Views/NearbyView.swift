//
//  SearchView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/15/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit

class NearbyView: UIView {
    
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
    
    let nearbyLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        lbl.text = "Great Places Nearby"
        lbl.textColor = .black
        
        return lbl
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
    
    let redoSearchAreaButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "Redo search area"
        btn.backgroundColor = .white
        btn.titleLabel?.textColor = .black
        btn.setAttributedTitle(NSAttributedString(
        string: "Redo search in this area",
        attributes: [NSAttributedString.Key.font: UIFont(name: "KohinoorTelugu-Regular", size: 15), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        btn.layer.cornerRadius = 5
        btn.alpha = 0
        return btn
    }()
    
    func setup() {
        addSubview(topblur)
        addSubview(bottomBlur)
        addSubview(mapView)
        addSubview(redoSearchAreaButton)
       // addSubview(nearbyLabel)
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
            make.bottom.equalToSuperview().inset(225)
        }
        redoSearchAreaButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.bottom.equalTo(topblur.snp.bottom).multipliedBy(0.6)
        }

        bringSubviewToFront(topblur)
        bringSubviewToFront(bottomBlur)
        bringSubviewToFront(redoSearchAreaButton)
       
    }
}
