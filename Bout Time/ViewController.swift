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
    var choosenEvents: [HistoricalEventStruct] = []
    var eventsTextLabel: [UILabel] = []
    
    // Text Label
    @IBOutlet weak var firstEvent: UILabel!
    @IBOutlet weak var secondEvent: UILabel!
    @IBOutlet weak var thirdEvent: UILabel!
    @IBOutlet weak var fourthEvent: UILabel!
    
    // Button
    @IBOutlet weak var firstEventDownButton: UIButton!
    @IBOutlet weak var secondEventUpButton: UIButton!
    @IBOutlet weak var secondEventDownButton: UIButton!
    @IBOutlet weak var thirdEventUpButton: UIButton!
    @IBOutlet weak var thirdEventDownButton: UIButton!
    @IBOutlet weak var fourthEventUpButton: UIButton!
    
    // Footer View
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    
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
            submitAnswer()
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
        feedbackButton.isHidden = true
        
        // We increment the number of events
        game.questionsAsked += 1
        
        choosenEvents = chooseEvents()
        
        // Create the array of labels
        eventsTextLabel = [firstEvent, secondEvent, thirdEvent, fourthEvent]
        
        // Fill in the array
        for index in 0..<choosenEvents.count {
            eventsTextLabel[index].text = choosenEvents[index].name
        }
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
        print(randomSelectedEvents)
        return randomSelectedEvents
    }
    
    func submitAnswer() {
        print("An answer has been submitted\n")
        timerLabel.isHidden = true
        shakeLabel.isHidden = true
        
        // We format the array of answers
        var eventsSubmitted: [String] = []
        for index in 0..<eventsTextLabel.count {
            eventsSubmitted.append(eventsTextLabel[index].text!)
        }
        
        choosenEvents = choosenEvents.sorted(by: {
            guard let event0 = $0.year as? Int else { return false }
            guard let event1 = $1.year as? Int else { return false }
            return event0 < event1
        })
        
        var rightOrderArray: [String] = []
        for event in choosenEvents {
            rightOrderArray.append(event.name)
        }
        
        if rightOrderArray == eventsSubmitted {
            guard let image: UIImage = UIImage(named: "next_round_success") else { fatalError("An error occurs") }
            feedbackButton.setImage(image, for: .normal)
        } else {
            guard let image: UIImage = UIImage(named: "next_round_fail") else { fatalError("An error occurs") }
            feedbackButton.setImage(image, for: .normal)
        }
        
        feedbackButton.isHidden = false
        
        print("Events before modification => \(rightOrderArray)\n")
        print("Events after modification => \(eventsSubmitted)\n")
    }
    
    // MARK: displayScore function
    func displayScore() -> Void {
        
    }
    
    // MARK: nextRound Function
    func nextRound() -> Void {
        if game.questionsAsked == game.questionsPerRound {
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
    
    // FIXME: Will need to put this in an other file
    enum Directions {
        case up
        case down
    }
    
    // MARK: Up and Down Label
    func updateEvents(to direction: Directions, from tag: Int) -> Void {
        if direction == Directions.up {
            let forwardEvent = eventsTextLabel[tag - 1].text
            let backwardEvent = eventsTextLabel[tag].text
            
            eventsTextLabel[tag - 1].text = backwardEvent
            eventsTextLabel[tag].text = forwardEvent
        } else {
            let forwardEvent = eventsTextLabel[tag].text
            let backwardEvent = eventsTextLabel[tag + 1].text
            
            eventsTextLabel[tag].text = backwardEvent
            eventsTextLabel[tag + 1].text = forwardEvent
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) -> Void {
        updateEvents(to: Directions.down, from: sender.tag)
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        updateEvents(to: Directions.up, from: sender.tag)
    }
}

