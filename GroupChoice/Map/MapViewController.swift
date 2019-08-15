//
//  BookmarksViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    var mapview : MKMapView!
    var mainView: UIView!
    var location = ""
    
    let bottomBlur: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bottom blur")
        return iv
    }()
    override func viewWillAppear(_ animated: Bool) {
        let tbvc = self.tabBarController as! TabBarViewController
        
        location = tbvc.location
        
        print (location)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView = view
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(collapseMap))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        mapview = MKMapView(frame: view.bounds)
        self.mapview.frame = self.view.bounds
        
        let topblur: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.image = UIImage(named: "top blur")
            return iv
        }()
        
        view.addSubview(mapview)
        view.addSubview(topblur)
        view.addSubview(bottomBlur)
        view.bringSubviewToFront(topblur)
        topblur.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        bottomBlur.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            
        }
        
        let expandGestureRecognizer = UITapGestureRecognizer()
        expandGestureRecognizer.numberOfTapsRequired = 1
        expandGestureRecognizer.addTarget(self, action: #selector(expandMap))
        mapview.addGestureRecognizer(expandGestureRecognizer)
    }
  
    
    @objc func expandMap() {
        mainView.bringSubviewToFront(mapview)
   
        zoomMap(byFactor: 2)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    @objc func collapseMap() {
        mainView.sendSubviewToBack(mapview)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        zoomOut(byFactor: 2)
    }
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.mapview.region
        var span: MKCoordinateSpan = mapview.region.span
        span.latitudeDelta /= delta
        span.longitudeDelta /= delta
        region.span = span
        mapview.setRegion(region, animated: true)
    }
    func zoomOut(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.mapview.region
        var span: MKCoordinateSpan = mapview.region.span
        span.latitudeDelta *= delta
        span.longitudeDelta *= delta
        region.span = span
        mapview.setRegion(region, animated: true)
    }
    
}
