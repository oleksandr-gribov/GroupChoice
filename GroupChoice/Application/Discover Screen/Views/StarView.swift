//
//  StarView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 4/29/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import UIKit

class StarView: UIView {
    enum Filler {
        case filled
        case half
        case empty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(_ filler: Filler) {
        self.init(frame: CGRect.zero)
        let iv = UIImageView()
        addSubview(iv)
        iv.frame = CGRect.zero
        iv.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview().inset(1)
        }
        iv.image = UIImage(named: "grey_check")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        switch filler {
        case .empty:
            iv.image = UIImage(named: "Clear-Star")
        case .half :
            iv.image = UIImage(named: "Half-Filled-Star")
        case .filled:
            iv.image = UIImage(named: "Filled-Star")
        }
        bringSubviewToFront(iv)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
