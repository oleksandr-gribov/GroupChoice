//
//  SearchTableViewCell.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/8/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var buttonChecked = false
    weak var delegate : SearchTableViewCellDelegate?
    var place : Place?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.myImageView.image = nil
        self.addButton.setImage(UIImage(named: "grey_check"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        setupCellStyle()
        setupViews()
        
        self.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func addButtonClicked() {
        buttonChecked = !buttonChecked
        if buttonChecked {
            addButton.setImage(UIImage(named: "blue_check"),for: .normal)
        } else {
            addButton.setImage(UIImage(named: "grey_check"),for: .normal)
        }
        self.delegate?.searchTableViewCell(buttonChecked, place: place!)
    }
    
    func setUpCellData(_ place: Place) {
        self.nameLabel.text = place.name
                      if let addressText = place.address {
                          self.addressLabel.text = addressText
                      } else {
                        self.addressLabel.text = "Address not available"
                      }
                      if let rating = place.rating {
                        self.ratingLabel.text = String(rating)
                      }
        self.descriptionTypes.text = typesDescription(place)
                      if let photos = place.photos  {
                          let reference = photos[0].reference
                          guard let url = GooglePlacesAPI.imageURL(reference: reference) else {
                              return
                          }
                          self.myImageView.fetchImage(url: url)
                      } else {
                          self.myImageView.image = #imageLiteral(resourceName: "no_image")
                      }
       
        }
    func typesDescription(_ place: Place) -> String {
        let types = place.types
        var index = types.count
        if index == 0  {
            return "Point of Interest"
        } else {
            var typesString = ""
            for i in 0..<types.count {
                if types[i] == "point_of_interest" {
                    index = i
                }
            }
            for i in 0..<index {
                let curr = types[i]
                let formatted = curr.replacingOccurrences(of: "_", with: " ")
                if i == index - 1 {
                    typesString += formatted.capitalized
                } else {
                    typesString += "\(formatted.capitalized), "
                }
            }
            return typesString
        }
    }
    
    func setupCellStyle() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
    }
    
    func setupViews() {
        addSubview(myImageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(ratingLabel)
        addSubview(distanceLabel)
        addSubview(locationPin)
        addSubview(starPin)
        addSubview(descriptionTypes)
        addSubview(addButton)
        
        myImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(100)
            make.width.equalTo(130)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(myImageView.snp.right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        descriptionTypes.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(myImageView.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(180)
        }
        ratingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(starPin.snp.right).offset(5)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        starPin.snp.makeConstraints { (make) in
            make.left.equalTo(myImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        addButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }
    
    
    let myImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        //iv.backgroundColor = .red
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name of place"
        //lbl.backgroundColor = .blue
        lbl.font = UIFont(name: "AvenirNext-Medium", size: 18)
        
        return lbl
    }()
    
    let descriptionTypes: UILabel = {
        let lbl = UILabel()
        lbl.text = "Coffee, Bar, Cool place"
        
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = false
        lbl.lineBreakMode = .byWordWrapping

        
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
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        return iv
    }()
    
    let ratingLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "4.5"
        lbl.font = lbl.font.withSize(15)
        
        return lbl
    }()
    
    let distanceLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "500m"
        lbl.font = lbl.font.withSize(9)
        
        return lbl
    }()
    
    let addButton: UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "grey_check"),for: .normal)
        btn.imageView?.image = UIImage(named: "grey_check")
        btn.isEnabled = true
        
        return btn
    }()
    
}

protocol SearchTableViewCellDelegate: AnyObject {
    func searchTableViewCell(_ buttonChecked: Bool, place: Place)
}
