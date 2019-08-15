//
//  PlacesCell.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/15/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit


class PlacesCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupCellStyle()
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellStyle() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(ratingLabel)
        addSubview(distanceLabel)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(85)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }
        ratingLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.backgroundColor = .green
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name of place"
        
        return lbl
    }()
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12 Smith Ave"
        lbl.font = lbl.font.withSize(12)
        lbl.textColor = .gray
        
        return lbl
    }()
    
    let ratingLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "4.5"
        lbl.font = lbl.font.withSize(9)
        return lbl
    }()
    
    let distanceLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "500m"
        lbl.font = lbl.font.withSize(9)
        
        return lbl
    }()
}
