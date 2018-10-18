//
//  ViewController.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/13/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

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
    
    // Obstacles
    // yellow FFD239
    let yellowC = UIColor(red: 1.0, green: 0.8235, blue: 0.2235, alpha: 1.0)
    // Green A7FEB1
    let greenC = UIColor(red: 0.6549, green: 0.9960, blue: 0.6941, alpha: 1.0)
    // Blue A32FFFF
    let blueC = UIColor(red: 0.196, green: 1.0, blue: 1.0, alpha: 1.0)
    
    
    // Max Sizes
    let MAX_DENSITY = 10000.0
    
    // Temp Score
    var score : Int = 0 {
        didSet {
            if score % 10 == 0 {
                // Add obstacle
                let type = arc4random_uniform(3) + 1
                let coo : CGPoint = giveMeCoords()
                createNewObstacle(type: Int(type), position: coo)
            }

        }
    }
    
    // Other stuff
    @IBOutlet weak var ScoreLabel: UILabel!
    // Sound
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always in landscape mode
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.view.backgroundColor = .black
        
        // MARK: - Creation of ball and racquet
        let ball = BallView(frame: CGRect(x: 0, y: CGFloat(self.view.bounds.minY), width: CGFloat(ballDiameter), height: CGFloat(ballDiameter)))
        
        let racquet = Racquet(frame: CGRect(x: CGFloat(CGFloat(self.view.bounds.midX * 0.3) - (CGFloat(racquetWidth) / CGFloat(2))), y: CGFloat(CGFloat(self.view.bounds.size.height) - CGFloat(spaceToBottom) - CGFloat(racquetHeight)), width: CGFloat(racquetWidth), height: CGFloat(racquetHeight)))

        ball.tag = 100
        racquet.tag = 101
        self.view.addSubview(ball)
        self.view.addSubview(racquet)
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        // MARK: - Adding physics
        self.gravity = UIGravityBehavior(items: [ball])
        self.gravity.magnitude = 0.5
        self.animator.addBehavior(self.gravity)
        
        // MARK: - Push
        self.ballPush = UIPushBehavior(items: [ball], mode: .instantaneous)
        self.ballPush.pushDirection = CGVector(dx: 0.2, dy: 0.5)
        self.ballPush.active = true
        self.animator.addBehavior(self.ballPush)
        
        
        // MARK: - Dynamic propierties to the racquet
        self.racquetDynamicProps = UIDynamicItemBehavior(items: [racquet])
        self.racquetDynamicProps.allowsRotation = false
        self.racquetDynamicProps.density = CGFloat(MAX_DENSITY)
        self.racquetDynamicProps.elasticity = 0.0
        self.racquetDynamicProps.friction = 1.0
        self.racquetDynamicProps.resistance = 1.0

        self.ballDynamicsProps = UIDynamicItemBehavior(items: [ball])
        self.ballDynamicsProps.allowsRotation = false
        self.ballDynamicsProps.density = 1.0
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
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let boundary = String(describing: identifier!)
        if boundary == "bottom" {
            // MARK: - You lose
            self.animator.removeAllBehaviors()
            showAlert()
        }
    }
    
    
    
    func showAlert(){
        // MARK: - Alert
        let alertController = UIAlertController(title: "Perdiste", message: "Puntaje: \(score)" , preferredStyle: .alert)
        let finishGame = UIAlertAction(title: "Ir a ver marcadores", style: .default) { (action:UIAlertAction) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let marcadores = storyBoard.instantiateViewController(withIdentifier: "marcadores") as! ScoresViewController
            self.present(marcadores, animated: true, completion: nil)
            
        }
        
        addScoreToTable()
        
        alertController.addAction(finishGame)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addScoreToTable() {
        let date = Date()
        bestScores.append(Score(hints: score, date: date))
        // Save the scores
        saveIntoUD()
//        print(bestScores)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if item1 is BallView {
            if item2 is Racquet {
                score = score + 1
                ScoreLabel.text = String(score)
                playSound()
            }
        }
  
    }
    
    func createNewObstacle(type: Int, position: CGPoint){
    
        var color : UIColor!
        let minimumSize = 25
        // Define colors for the obstacles
        if type == 1 {
            color = self.greenC
        }
        if type == 2 {
            color = self.blueC
        }
        if type == 3 {
            color = self.yellowC
        }
        
//        print(type)
        
        let obstacle = Obstacle(frame: CGRect(x: position.x, y: position.y, width: CGFloat(minimumSize * type), height: CGFloat(minimumSize)), color: color)
        
    
//        self.view.addSubview(obstacle)
        self.view.insertSubview(obstacle, belowSubview: ScoreLabel)
        let obstacleBH = UIDynamicItemBehavior(items: [obstacle])
        obstacleBH.isAnchored = true
        
        self.collision.addItem(obstacle)
        self.racquetDynamicProps.addItem(obstacle)
        self.animator.addBehavior(obstacleBH)
    }
    
    func giveMeCoords() -> CGPoint {
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        // Get the random coords
        var x = arc4random_uniform(UInt32(width))
        var y = arc4random_uniform(UInt32(height * 0.75))
        
        // Reduce the guard bands
        if x < Int(width / 2) {
            x = x + 25
        }
        else if x > Int(width / 2){
            x = x - 25
        }
        
        if y < Int((height * 0.75) / 2) {
            y = y + 25
        }
        else if y > Int((height * 0.75) / 2){
            y = y - 25
        }
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))

    }
    
    func giveMeColor() -> UIColor {
        let red = Double(arc4random() % 100)/100.0;
        let blue = Double(arc4random() % 100)/100.0;
        let green = Double(arc4random() % 100)/100.0;
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
    
    // MARK: - Racquet movent along screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch! = touches.first
        var location = touch.location(in: self.view)
        if location.x < 0 {
            location.x = CGFloat(racquetWidth/2)
        }
        else if location.x > self.view.bounds.size.width {
            location.x = CGFloat(self.view.bounds.size.width - CGFloat(racquetWidth/2))
        }
        let racquetView = self.view.viewWithTag(101)
        racquetView?.center = CGPoint(x: location.x, y: (racquetView?.center.y)!)
        self.animator.updateItem(usingCurrentState: racquetView!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch! = touches.first
        var location = touch.location(in: self.view)
        if location.x < 0 {
            location.x = CGFloat(racquetWidth/2)
        }
        else if location.x > self.view.bounds.size.width {
            location.x = CGFloat(self.view.bounds.size.width - CGFloat(racquetWidth/2))
        }
        let racquetView = self.view.viewWithTag(101)
        racquetView?.center = CGPoint(x: location.x, y: (racquetView?.center.y)!)
        self.animator.updateItem(usingCurrentState: racquetView!)
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "whoosh", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}

