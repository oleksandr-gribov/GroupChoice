//
//  DownloadsViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Discover"
        setupNavBar()
        
        
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
