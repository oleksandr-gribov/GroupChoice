//
//  SearchTableViewCell.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/8/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setupCellStyle()
        setupViews()
        
    }
    
   
    func setupCellStyle() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        //self.layer.borderWidth = 0.5
        //self.layer.borderColor = UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0).cgColor
            //UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0) as! CGColor
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
    }
    
    
    let myImageView : CustomImageView = {
         let iv = CustomImageView()
         iv.contentMode = .scaleAspectFill
         iv.clipsToBounds = true
         iv.layer.cornerRadius = 5
    
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
