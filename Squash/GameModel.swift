//
//  GameModel.swift
//  Squash
//
//  Created by Dante Bazaldua on 10/14/18.
//  Copyright © 2018 Dante Bazaldua. All rights reserved.
//

import Foundation

struct Score {
    var hints : Int
    var date : Date!
}

var bestScores = [Score]()

func getOrderedValues(bestScores: [Score]) -> [Score] {
    var newScores = [Score]()
    if bestScores.count == 0 {
        for _ in 0..<5{
            newScores.append(Score(hints: 0, date: nil))
        }
    }
    else{
        newScores = bestScores.sorted(by: {
            (h1: Score, h2: Score) -> Bool
            in return h1.hints > h2.hints
        })
        if newScores.count < 5 {
            for _ in 0..<(5-newScores.count) {
                newScores.append(Score(hints: 0, date: nil))
            }
        }
    }
    return newScores
}

func saveIntoUD() {
    let defaults = UserDefaults.standard
    var scoreStr = String()
    defaults.removeObject(forKey: "SquashAppScores")
    if bestScores.count > 0 {
        print(bestScores.count)
        for element in bestScores {
            scoreStr += "\(element.hints)|\(getDateWithFormat(date:element.date)),"
        }
//        print("Score \(scoreStr)")
        defaults.set(scoreStr, forKey: "SquashAppScores")
    }
}

func getScoresUD() {
    
    let defaults = UserDefaults.standard
    let data = defaults.string(forKey: "SquashAppScores")
    var newScores = [Score]()

    if data != nil {

        var scores = data?.components(separatedBy: ",")
        if (scores?.count)! > 0 {
            let size = scores?.count
            scores?.remove(at: size! - 1 )
            for el in scores! {
                let score = el.components(separatedBy: "|")
//                print("DEBUG: \(score)")
                let hint = Int(score[0])
                let date = getDateFromFormat(date: score[1])
                newScores.append(Score(hints: hint!, date: date))
            }
            bestScores = newScores
        }
    }
    
}

func getDateFromFormat(date: String) -> Date {
    //    Took idea from: https://stackoverflow.com/questions/36861732/swift-convert-string-to-date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd:MM:yyy hh:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    let date = dateFormatter.date(from: date)!
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    let finalDate = calendar.date(from:components)
    return finalDate!
}

func getDateWithFormat(date: Date) -> String {
    // Idea took from https://stackoverflow.com/questions/46993632/getting-date-and-time-from-a-time-zone-in-swift4
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd:MM:yyy hh:mm:ss"
    let timeZone = TimeZone(identifier: "America/Mexico_City")
    dateFormatter.timeZone = timeZone
    return dateFormatter.string(from: date)
}
