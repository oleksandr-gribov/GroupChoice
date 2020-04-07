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
        topSquare.addSubview(optionsLabel)
        addSubview(tableView)
        addSubview(mapView)
        addSubview(customView)
        bringSubviewToFront(topSquare)
        
        topSquare.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        customView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.bottom.equalToSuperview().inset(30)
        }
       
        customView.addSubview(imageView)
        customView.addSubview(nameLabel)
        customView.addSubview(addressLabel)
        customView.addSubview(openNow)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9  )
            make.height.equalToSuperview().multipliedBy(0.5)
            
        }
        
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        openNow.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp_bottom).offset(7)
            make.left.equalToSuperview().inset(20)
            
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            
        }
        
        
        optionsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
       
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topSquare.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
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
    
    let customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = .white
        customView.isHidden = true
        customView.layer.cornerRadius = 10
//        if #available(iOS 13.0, *) {
//            customView.layer.borderColor = CGColor.init(srgbRed: 0/255, green: 0/255, blue: 255/255, alpha: 0.8)
//        } else {
//            // Fallback on earlier versions
//        }
//        customView.layer.borderWidth = 3
        
        customView.layer.shadowOffset = CGSize(width: 1, height: 1)
        customView.layer.shadowOpacity = 0.25
        return customView
    }()

    
    let imageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name of place that is very long to check "
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = lbl.font.withSize(18)
        lbl.adjustsFontSizeToFitWidth = false
        
        return lbl
    }()
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12 Smith Ave"
        lbl.font = lbl.font.withSize(16)
        lbl.textColor = .gray
        lbl.adjustsFontSizeToFitWidth = false
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    let openNow: UILabel = {
           let lbl = UILabel()
           lbl.font = lbl.font.withSize(16)
           lbl.textColor = .green
           
           
           return lbl
       }()
  
}


