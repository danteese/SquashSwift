//
//  Obstacle.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/14/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit

class Obstacle: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.borderWidth = 4
        self.layer.borderColor = color.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
