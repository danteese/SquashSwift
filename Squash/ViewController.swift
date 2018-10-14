//
//  ViewController.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/13/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit

// UICollisionBehaviorDelegate in order to track the collisions
class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var racquetDynamicProps : UIDynamicItemBehavior!
    var ballDynamicsProps : UIDynamicItemBehavior!
    
    // Movement and hits
    var ballPush : UIPushBehavior!
    
    // Initial Sizes
    let ballDiameter = 30
    let spaceToBottom = 40
    let racquetWidth = 100
    let racquetHeight = 25
    
    // Temp Score
    var score = 0
    
    // Other stuff
    @IBOutlet weak var ScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always in landscape mode
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.view.backgroundColor = .black
        
        // MARK: - Creation of ball and racquet
        let ball = BallView(frame: CGRect(x: CGFloat(self.view.bounds.midX), y: CGFloat(self.view.bounds.minY), width: CGFloat(ballDiameter), height: CGFloat(ballDiameter)))
        
        let racquet = Racquet(frame: CGRect(x: CGFloat(CGFloat(self.view.bounds.midX) - (CGFloat(racquetWidth) / CGFloat(2))), y: CGFloat(CGFloat(self.view.bounds.size.height) - CGFloat(spaceToBottom) - CGFloat(racquetHeight)), width: CGFloat(racquetWidth), height: CGFloat(racquetHeight)))

        ball.tag = 100
        racquet.tag = 101
        self.view.addSubview(ball)
        self.view.addSubview(racquet)
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        // MARK: - Adding physics
        self.gravity = UIGravityBehavior(items: [ball])
        self.animator.addBehavior(self.gravity)
        
        // MARK: - Push
        self.ballPush = UIPushBehavior(items: [ball], mode: .instantaneous)
        self.ballPush.pushDirection = CGVector(dx: 0.4, dy: 1.0)
        self.ballPush.active = true
        self.animator.addBehavior(self.ballPush)
        
        
        // MARK: - Dynamic propierties to the racquet
        self.racquetDynamicProps = UIDynamicItemBehavior(items: [racquet])
        self.racquetDynamicProps.allowsRotation = false
        self.racquetDynamicProps.density = 10000.0
        self.racquetDynamicProps.elasticity = 0.0
        self.racquetDynamicProps.friction = 1.0
        self.racquetDynamicProps.resistance = 1.0

        self.ballDynamicsProps = UIDynamicItemBehavior(items: [ball])
        self.ballDynamicsProps.allowsRotation = false
        self.ballDynamicsProps.elasticity = 1.0
        self.ballDynamicsProps.friction = 0.0
        self.ballDynamicsProps.resistance = 0.0
        

        // MARK: - Adding behaviors
        self.animator.addBehavior(self.racquetDynamicProps);
        self.animator.addBehavior(self.ballDynamicsProps);
        
        
        // MARK: - Collisions
        self.collision = UICollisionBehavior(items: [ball, racquet])
        self.collision.collisionDelegate = self
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.collision.collisionMode = .everything
        // MARK: - Add boundaries to the main screen
        self.collision.addBoundary(withIdentifier: "top" as NSString, from: CGPoint(x: 0, y: 0), to: CGPoint(x: self.view.bounds.size.width, y: 0))
        self.collision.addBoundary(withIdentifier: "bottom" as NSString, from: CGPoint(x: 0, y: self.view.bounds.size.height), to: CGPoint(x: self.view.bounds.size.width, y: self.view.bounds.size.height))
        self.collision.addBoundary(withIdentifier: "left" as NSString, from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: self.view.bounds.size.height))
        self.collision.addBoundary(withIdentifier: "right" as NSString, from: CGPoint(x: self.view.bounds.size.width, y: 0), to: CGPoint(x: self.view.bounds.size.width, y: self.view.bounds.size.height))
        
        self.animator.addBehavior(self.collision)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point : CGPoint = (touches.first?.location(in: self.view))!

        let racquetView = self.view.viewWithTag(101)
        racquetView?.center = point

        self.animator.updateItem(usingCurrentState: racquetView!)
        print("Raqueta movida \(point.x),\(point.y)")
//        print("It moved to: \(point.x),\(point.y)")
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let boundary = String(describing: identifier!)
        if boundary == "bottom" {
            print("Perdiste")
            print(getDateWithFormat())
        }
        else{
            // Add something to score
            score = score + 1
            ScoreLabel.text = String(score)
        }

    }
    
    func getDateWithFormat() -> String {
        // Idea took from https://stackoverflow.com/questions/46993632/getting-date-and-time-from-a-time-zone-in-swift4
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yyy hh:mm:ss"
        let timeZone = TimeZone(identifier: "America/Mexico_City")
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: Date())
    }
    
    

}

