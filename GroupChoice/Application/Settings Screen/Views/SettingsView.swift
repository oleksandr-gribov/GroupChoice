//
//  SettingsView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/29/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradientLayer = CAGradientLayer()
        backgroundColor = .white
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(red: 150/255, green: 211/255, blue: 255/255, alpha: 0.5).cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
    func setupBackground() {
        
        
    }
    
}
