//
//  ViewController.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/13/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var animator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var racquetDynamicProps : UIDynamicItemBehavior!
    var ballDynamicsProps : UIDynamicItemBehavior!
    
    // Raquet positions
//    var racquetX : CGFloat = CGFloat(CGFloat(self.view.bounds.size.height) - CGFloat(spaceToBottom) - CGFloat(racquetHeight))
//    var racquetY : CGFloat = CGFloat(CGFloat(self.view.bounds.size.height) - CGFloat(spaceToBottom) - CGFloat(racquetHeight))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always in landscape mode
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
//        print("W: \(self.view.bounds.size.width) H: \(self.view.bounds.size.height)")
        
        let ballDiameter = 18
        let spaceToBottom = 40
        let racquetWidth = 100
        let racquetHeight = 20

        // MARK: - Creation of ball and racquet
        let ball = BallView(frame: CGRect(x: CGFloat(self.view.bounds.midX), y: CGFloat(self.view.bounds.minY), width: CGFloat(ballDiameter), height: CGFloat(ballDiameter)))
        
        let racquet = Racquet(frame: CGRect(x: CGFloat(CGFloat(self.view.bounds.midX) - (CGFloat(racquetWidth) / CGFloat(2))), y: CGFloat(CGFloat(self.view.bounds.size.height) - CGFloat(spaceToBottom) - CGFloat(racquetHeight)), width: CGFloat(racquetWidth), height: CGFloat(racquetHeight)))

        
        self.view.addSubview(ball)
        self.view.addSubview(racquet)
        
        
        // MARK: - Adding physics
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.gravity = UIGravityBehavior(items: [ball])
        self.animator.addBehavior(self.gravity)
        
        // MARK: - Dynamic propierties to the racquet
        self.racquetDynamicProps = UIDynamicItemBehavior(items: [racquet])
        self.racquetDynamicProps.allowsRotation = false
        self.racquetDynamicProps.density = 1000

        self.ballDynamicsProps = UIDynamicItemBehavior(items: [ball])
        self.ballDynamicsProps.elasticity = 1.0
        self.ballDynamicsProps.friction = 0.0
        self.ballDynamicsProps.resistance = 0.0

        
        self.animator.addBehavior(self.racquetDynamicProps);
        self.animator.addBehavior(self.ballDynamicsProps);
        
        
        // MARK: - Collisions
        self.collision = UICollisionBehavior(items: [ball, racquet])
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collision)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint.zero
        for touch in touches {
            point = touch.location(in: self.view)
            print("It moved to: \(point.x),\(point.y)")
        }
    }


}

