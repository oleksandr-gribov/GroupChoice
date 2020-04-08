//
//  SearchPlacesCollectionViewCell.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/8/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class SearchPlacesCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupCellView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    func setupData(_ place: Place) {
        self.nameLabel.text = place.name
        if let photos = place.photos  {
            let reference = photos[0].reference
            guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                return
            }
            self.imageView.fetchImage(url: url)
        } else {
            self.imageView.image = #imageLiteral(resourceName: "no_image")
        }
    }
    
    func setupCellView() {
        addSubview(imageView)
        addSubview(nameLabel)

        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            
        }
    }
    
    let imageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        iv.layer.cornerRadius = iv.frame.size.width/2
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        lbl.adjustsFontSizeToFitWidth = false
        lbl.font = UIFont(name: "AvenirNext-Medium", size: 15)
        return lbl
    }()
}
