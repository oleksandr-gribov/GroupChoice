//
//  PlaceDetailView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/19/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MapKit

class PlaceDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        horizontalStack.addArrangedSubview(descriptionTypes)
        horizontalStack.addArrangedSubview(openNow)
        addSubview(imageView)
        addSubview(backgroundCard)
        let subviews = [nameLabel, addressLabel, horizontalStack, locationPin, starPin, ratingLabel, distanceLabel, mapView, reviewStack, numOfReviews]
        
        subviews.forEach { [weak self] in
            backgroundCard.addSubview($0)
        }
        backgroundCard.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(20)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        horizontalStack.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(8)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(imageView).inset(20)
            
        }
        reviewStack.snp.makeConstraints { (make) in
    
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(horizontalStack.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(20)
        }
        numOfReviews.snp.makeConstraints { (make) in
            make.left.equalTo(reviewStack.snp.right).offset(5)
            make.top.equalTo(reviewStack.snp.top)
            make.bottom.equalTo(reviewStack.snp.bottom)
            make.width.equalTo(120)
        }
        bringSubviewToFront(reviewStack)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.top).inset(-25)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(20)
            
        }
        
        mapView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    func setupReviewStack(_ place: Place) {
        if let rating = place.rating {
            let wholeRating = rating.rounded(.down)
            
            let numWholeStars = Int(wholeRating)
            var halfStars = 0
            var emptyStars = 0
            
            if wholeRating < 5.0 {
                let isInteger = floor(rating)
                if isInteger != rating {
                    halfStars = 1
                }
            }
            for _ in 1...numWholeStars {
                let starview = StarView.init(.filled)
                reviewStack.addArrangedSubview(starview)
            }
            if halfStars != 0 {
                let starview = StarView.init(.half)
                reviewStack.addArrangedSubview(starview)
            }
            if (5 - numWholeStars - halfStars) >= 1 {
                let starview = StarView.init(.empty)
                reviewStack.addArrangedSubview(starview)
                emptyStars += 1
            }
            print("Stars to print \(numWholeStars), \(halfStars), \(emptyStars)")
        }
        
    }
    
    let reviewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .fillEqually
        return stack
    }()
    
    let numOfReviews: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        return lbl
    }()
    
    let filledImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return iv
    }()
    
    let halfImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return iv
    }()
    
    let emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return iv
    }()
    let backgroundCard : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
   
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name of place"
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = lbl.font.withSize(25)
        
        return lbl
    }()
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12 Smith Ave"
        lbl.font = lbl.font.withSize(16)
        lbl.textColor = .gray
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let descriptionTypes: UILabel = {
        let lbl = UILabel()
        lbl.text = "Coffee, Bar, Cool place"
        lbl.font = lbl.font.withSize(16)
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = false
       // lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    let openNow: UILabel = {
        let lbl = UILabel()
        lbl.font = lbl.font.withSize(16)
        lbl.textColor = .green
        lbl.textAlignment = .right
        
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
    
    let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "4.5"
        lbl.font = lbl.font.withSize(9)
        
        return lbl
    }()
    
    let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "500m"
        lbl.font = lbl.font.withSize(9)
        
        return lbl
    }()
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        
        return mv
    }()
    
    let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()
    
}
