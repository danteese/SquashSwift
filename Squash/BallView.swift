//
//  BallView.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/13/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit

@IBDesignable
class BallView: UIView {
    
    private var ballColor : UIColor = .black {
        didSet {
            setNeedsDisplay() // Cambia el color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initBall()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBall()
    }
    
    func initBall(){
        self.ballColor = .black
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath();
        
//        print("Real size: W: \(rect.width) H: \(rect.height)")
        
        // Always start on top
        let radius = 15
        let centre = CGPoint(x: CGFloat(rect.size.width/2), y: CGFloat(rect.size.height/2))
        path.move(to: CGPoint(x: centre.x + CGFloat(radius), y: centre.y))
        path.addArc(withCenter: centre, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)

        
        // Idea from: https://stackoverflow.com/questions/29616992/how-do-i-draw-a-circle-in-ios-swift
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        shapeLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(shapeLayer)
    }
 
    
    

}
