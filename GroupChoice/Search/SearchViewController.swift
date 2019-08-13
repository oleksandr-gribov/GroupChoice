//
//  DownloadsViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    let placesCellId = "placesCellId"
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placesCellId, for: indexPath) as! PlacesCell
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2.5)-16, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.title = "Discover"
        setupNavBar()
        
        collectionView.register(PlacesCell.self, forCellWithReuseIdentifier: placesCellId)
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
            make.right.equalToSuperview()
            make.height.equalTo(250)
            //make.top.equalToSuperview().offset(400)
        }
        
        
        let backgroundImage = UIImageView(image: UIImage(imageLiteralResourceName: "Background"))
        backgroundImage.contentMode = .scaleAspectFill
        let backgroundGetsureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundImageTapped))
        backgroundGetsureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(backgroundGetsureRecognizer)
        
        
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        view.bringSubviewToFront(collectionView)
        
    }
    
    @objc func backgroundImageTapped() {
        navigationController?.tabBarController?.selectedIndex = 3
    }
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        let photoView : UIView = {
            let pv = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
            pv.layer.cornerRadius = 23
            pv.backgroundColor = .black
           
            return pv
        }()

        photoView.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: photoView)
    }
    
    
}

class PlacesCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(ratingLabel)
        addSubview(distanceLabel)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-90)
            //make.height.equalTo(300)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
