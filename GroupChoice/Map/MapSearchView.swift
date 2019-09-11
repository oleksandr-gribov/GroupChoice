//
//  MapView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/9/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class MapSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addSubview(topSquare)
        
        topSquare.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(100)
        }
        topSquare.addSubview(optionsLabel)
        
        optionsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        topSquare.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(optionsLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topSquare.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        bringSubviewToFront(optionsLabel)
        bringSubviewToFront(locationLabel)
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
    
    let optionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Restaurant, bars, movies, etc"
        lbl.backgroundColor = .white
        lbl.isUserInteractionEnabled = true 
        return lbl
    }()
    
    let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Current Location"
        lbl.backgroundColor = .white
        return lbl
    }()
    let tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
}
