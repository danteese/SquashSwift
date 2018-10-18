//
//  ScoresViewController.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/14/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController {

    @IBOutlet weak var Hints1: UILabel!
    @IBOutlet weak var Date1: UILabel!
    @IBOutlet weak var Hints2: UILabel!
    @IBOutlet weak var Date2: UILabel!
    @IBOutlet weak var Hints3: UILabel!
    @IBOutlet weak var Date3: UILabel!
    @IBOutlet weak var Hints4: UILabel!
    @IBOutlet weak var Date4: UILabel!
    @IBOutlet weak var Hints5: UILabel!
    @IBOutlet weak var Date5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // User defaults
        getScoresUD()
        let hints = [Hints1, Hints2, Hints3, Hints4, Hints5]
        let dates = [Date1, Date2, Date3, Date4, Date5]
        let scores = getOrderedValues(bestScores: bestScores)
        var i = 0
        if scores.count > 0 {
            for i in 0..<5 {
                hints[i]?.text = "\(scores[i].hints)"
                if scores[i].date == nil {
                    dates[i]?.text = "-"
                }
                else{
                    dates[i]?.text = "\(getDateWithFormat(date: scores[i].date))"
                }
            }
        }
        else{
            i = 0
            for _ in 0..<5 {
                hints[i]?.text = "0"
                dates[i]?.text = "-"
                i = i + 1
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
