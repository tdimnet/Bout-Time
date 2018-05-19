//
//  ViewController.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 14/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Class properties
    var game: GameManager
    
    // Global variables
    var questions: [HistoricalEventStruct] = []
    
    // IB
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HistoricalEvents", ofType: "plist")
            guard let historicalEventsinventory: [HistoricalEventStruct] = try HistoricalEventsUnarchiver.historicalEventsInventory(fromDictionary: dictionary) as? [HistoricalEventStruct] else {
                // FIXME: Add a better work for the inventory
                fatalError()
            }
            self.game = GameManager(dictionary: historicalEventsinventory)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questions = game.questionsDictionary
        print(questions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func gameStart() -> Void {
        
    }
    
    func displayQuestion() -> Void {
        
    }
    
    func displayScore() -> Void {
        
    }
    
    func nextRound() -> Void {
        
    }

    func startTimer() -> Void {
        
    }
    
    func stopTimer() -> Void {
        
    }
    
    func timerIsRunning() -> Void {
        
    }
    
    func timeOut() -> Void {
        
    }
}

