//
//  ViewController.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 14/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    // Class properties
    var game: GameManager
    
    // Global variables
    var events: [HistoricalEventStruct] = []
    
    // IB
    @IBOutlet weak var firstEvent: UILabel!
    @IBOutlet weak var secondEvent: UILabel!
    @IBOutlet weak var thirdEvent: UILabel!
    @IBOutlet weak var fourthEvent: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HistoricalEvents", ofType: "plist")
            guard let historicalEventsinventory: [HistoricalEventStruct] = try HistoricalEventsUnarchiver.historicalEventsInventory(fromDictionary: dictionary) as? [HistoricalEventStruct] else {
                // FIXME: Add a better work for the inventory
                fatalError()
            }
            self.game = GameManager(questionsDictionary: historicalEventsinventory, gameScore: 0, timer: 20, questionsPerRound: 5, questionsAsked: 0)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Shaking Event
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            displayEvents()
        }
    }

    // MARK: gameStart Function
    func gameStart() -> Void {
        // Fill in the questions array
        events = game.questionsDictionary
        displayEvents()
    }
    
    // MARK: displayEvents Function
    func displayEvents() -> Void {
        let choosenEvents: [HistoricalEventStruct] = chooseEvents()
        
        firstEvent.text = choosenEvents[0].name
        secondEvent.text = choosenEvents[1].name
        thirdEvent.text = choosenEvents[2].name
        fourthEvent.text = choosenEvents[3].name
    }
    
    // MARK: chooseEvents Function
    func chooseEvents() -> [HistoricalEventStruct] {
        var randomSelectedEvents: [HistoricalEventStruct] = []
        for _ in 0..<4 {
            let randomIndex: Int = GKRandomSource.sharedRandom().nextInt(upperBound: events.count)
            
            // Adding the 4 questions to the randomSelectedQuestions
            randomSelectedEvents.append(events[randomIndex])
            
            // And removing the 4 questions from the questions array
            events.remove(at: randomIndex)
        }
        return randomSelectedEvents
    }
    
    // MARK: displayScore function
    func displayScore() -> Void {
        
    }
    
    // MARK: nextRound Function
    func nextRound() -> Void {
        if game.questionsAsked == game.questionsAsked {
            displayScore()
        } else {
            displayEvents()
        }
    }

    // MARK: startTimer function
    func startTimer() -> Void {
        
    }
    
    // MARK: stopTimer Function
    func stopTimer() -> Void {
        
    }
    
    // MARK: timerIsRunning Function
    func timerIsRunning() -> Void {
        
    }
    
    // MARK: timeOut Function
    func timeOut() -> Void {
        
    }
}

