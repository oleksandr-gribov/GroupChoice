//
//  CustomView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/20/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.25
        
        
        addSubview(imageView)
        bringSubviewToFront(imageView)
        addSubview(nameLabel)
        bringSubviewToFront(nameLabel)
        addSubview(addressLabel)
        bringSubviewToFront(addressLabel)
         
         imageView.snp.makeConstraints { (make) in
             make.top.equalToSuperview().offset(15)
             make.centerX.equalToSuperview()
             make.width.equalToSuperview().multipliedBy(0.9)
             make.height.equalToSuperview().multipliedBy(0.5)
             
         }
         
         nameLabel.snp.makeConstraints { (make) in
             make.top.equalTo(imageView.snp.bottom).offset(10)
             make.left.equalToSuperview().inset(20)
             make.width.equalToSuperview().multipliedBy(0.5)
         }
         
        
         addressLabel.snp.makeConstraints { (make) in
             make.top.equalTo(nameLabel.snp.bottom).offset(10)
             make.left.equalToSuperview().inset(20)
             make.width.equalToSuperview().multipliedBy(0.8)
             
         }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let customView: UIView = {
          let customView = UIView()
          customView.backgroundColor = .white
          customView.isHidden = false
          customView.layer.cornerRadius = 10
          customView.layer.shadowOffset = CGSize(width: 1, height: 1)
          customView.layer.shadowOpacity = 0.25
          
          return customView
      }()
      
      let imageView: CustomImageView = {
          let iv = CustomImageView()
          iv.contentMode = .scaleAspectFill
          iv.clipsToBounds = true
          iv.backgroundColor = .white
          
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
