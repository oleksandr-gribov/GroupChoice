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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(ratingLabel)
        addSubview(distanceLabel)
        addSubview(locationPin)
        addSubview(starPin)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(85)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.left.equalTo(locationPin.snp.right).offset(5)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        ratingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(starPin.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
        locationPin.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.top)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(13)
            make.width.equalTo(11)
        }
        starPin.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(11.5)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
    }
    
    let imageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
       // iv.backgroundColor = .green
        
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
        lbl.adjustsFontSizeToFitWidth = false
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let locationPin: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Location pin")
        return iv
    }()
    
    let starPin: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Path")
        
        return iv
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

let imageCache = NSCache<NSString, UIImage>()


class CustomImageView: UIImageView {
    
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    var imageUrl : String?
    
    
    func fetchImage(url: URL)  {
        let urlString = url.absoluteString
        imageUrl = urlString
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.activityIndicator.startAnimating()
        image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            self.activityIndicator.stopAnimating()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, err, response) in
            
            if let data = data {
                
                let imageData = UIImage(data: data)
                DispatchQueue.main.async {
                    if self.imageUrl == url.absoluteString {
                        self.image = imageData
                        imageCache.setObject(imageData!, forKey: urlString as NSString)
                        self.activityIndicator.stopAnimating()
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.image = #imageLiteral(resourceName: "no_image")
                        }
                    }
                    
                }
                
            } else {
                
            }
        })
        task.resume()
    }
}
