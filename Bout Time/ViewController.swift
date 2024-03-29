//
//  ViewController.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 14/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import UIKit
import GameKit
import SafariServices

class ViewController: UIViewController {
    
    // Class properties
    var game: GameManager
    var timer: TimerManager
    
    // Global variables: Events
    var events: [HistoricalEventStruct] = []
    var choosenEvents: [HistoricalEventStruct] = []
    var eventsTextLabel: [UILabel] = []
    
    // Global variables: Timer
    
//    var timerIsOn: Bool = false
//    var oldTimer: Timer = Timer()
//    var timeRemaining: Int = 60
//    var totalTime: Int = 60
    
    
    // MARK: Events Stack View.
    // Stack View
    @IBOutlet weak var eventStackView: UIStackView!
    
    // Text Label
    @IBOutlet weak var firstEvent: UILabel!
    @IBOutlet weak var secondEvent: UILabel!
    @IBOutlet weak var thirdEvent: UILabel!
    @IBOutlet weak var fourthEvent: UILabel!
    
    // See more buttons
    @IBOutlet weak var firstSeeMore: UIButton!
    @IBOutlet weak var secondSeeMore: UIButton!
    @IBOutlet weak var thirdSeeMore: UIButton!
    @IBOutlet weak var fourthSeeMore: UIButton!
    
    
    // Button
    @IBOutlet weak var firstEventDownButton: UIButton!
    @IBOutlet weak var secondEventUpButton: UIButton!
    @IBOutlet weak var secondEventDownButton: UIButton!
    @IBOutlet weak var thirdEventUpButton: UIButton!
    @IBOutlet weak var thirdEventDownButton: UIButton!
    @IBOutlet weak var fourthEventUpButton: UIButton!
    
    
    // MARK: Game score view
    @IBOutlet weak var gameScoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: Footer label
    // Footer View
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HistoricalEvents", ofType: "plist")
            guard let historicalEventsinventory: [HistoricalEventStruct] = HistoricalEventsUnarchiver.historicalEventsInventory(fromDictionary: dictionary) as? [HistoricalEventStruct] else {
                // FIXME: Add a better work for the inventory
                fatalError()
            }
            self.game = GameManager(questionsDictionary: historicalEventsinventory, gameScore: 0, questionsPerRound: 6, questionsAsked: 0)
            self.timer = TimerManager(timerIsOn: false, timer: Timer(), timeRemaining: 60, totalTime: 60)
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
        game.gameScore = 0
        game.questionsAsked = 0
        
        gameScoreView.isHidden = true
        
        eventStackView.isHidden = false
        shakeLabel.isHidden = false
        timerLabel.isHidden = false
        
        events = game.questionsDictionary
        displayEvents()
    }
    
    // MARK: displayEvents Function
    func displayEvents() -> Void {
        
        firstSeeMore.isHidden = true
        secondSeeMore.isHidden = true
        thirdSeeMore.isHidden = true
        fourthSeeMore.isHidden = true
        
        feedbackButton.isHidden = true
        shakeLabel.text = "Shake to complete"
        
        startTimer()
        
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
        return randomSelectedEvents
    }
    
    func submitAnswer() {
        shakeLabel.text = "Tap events to learn more"
        timerLabel.text = "0:60"
        
        firstSeeMore.isHidden = false
        
        
        if let firstTextEvent = firstEvent.text, let secondTextEvent = secondEvent.text, let thirdTextEvent = thirdEvent.text, let fourthTextEvent = fourthEvent.text {
            firstSeeMore.setTitle(firstTextEvent, for: .normal)
            firstSeeMore.setTitle(firstTextEvent, for: .highlighted)
            
            secondSeeMore.setTitle(secondTextEvent, for: .normal)
            secondSeeMore.setTitle(secondTextEvent, for: .highlighted)
            
            thirdSeeMore.setTitle(thirdTextEvent, for: .normal)
            thirdSeeMore.setTitle(thirdTextEvent, for: .highlighted)
            
            fourthSeeMore.setTitle(fourthTextEvent, for: .normal)
            fourthSeeMore.setTitle(fourthTextEvent, for: .highlighted)
        }
        
        
        secondSeeMore.isHidden = false
        thirdSeeMore.isHidden = false
        fourthSeeMore.isHidden = false
        
        stopTimer()
        
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
            game.gameScore += 1
        } else {
            guard let image: UIImage = UIImage(named: "next_round_fail") else { fatalError("An error occurs") }
            feedbackButton.setImage(image, for: .normal)
        }
        
        feedbackButton.isHidden = false
    }
    
    // MARK: displayScore function
    func displayScore() -> Void {
        gameScoreView.isHidden = false
        
        eventStackView.isHidden = true
        
        feedbackButton.isHidden = true
        shakeLabel.isHidden = true
        timerLabel.isHidden = true
        
        scoreLabel.text = "\(game.gameScore)/6"
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
        if !timer.timerIsOn {
            timer.timeRemaining = 60
            // FIXME: compiler error when this method is called
            timer.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerIsRunning), userInfo: nil, repeats: true)
            timer.timerIsOn = true
            
        }
    }
    
    // MARK: stopTimer Function
    func stopTimer() -> Void {
        if timer.timerIsOn {
            timer.timer.invalidate()
            timer.timerIsOn = false
        }
    }
    
    // MARK: timerIsRunning Function
    @objc func timerIsRunning() -> Void {
        if timer.timeRemaining >= 0 {
            timerLabel.text = "0:\(timer.timeRemaining)"
        } else {
            timeOut()
        }
        timer.timeRemaining -= 1
    }
    
    // MARK: timeOut Function
    func timeOut() -> Void {
        timer.timer.invalidate()
        timer.timerIsOn = false
        submitAnswer()
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
    
    @IBAction func upButtonPressed(_ sender: UIButton) -> Void {
        updateEvents(to: Directions.up, from: sender.tag)
    }
    
    @IBAction func launchNextRound(_ sender: UIButton) -> Void {
        nextRound()
    }
    
    @IBAction func startNewGameButton(_ sender: UIButton) {
        gameStart()
    }
    
    // MARK: See more events
    @IBAction func seeMoreWebView(_ sender: UIButton) {
        if let label = sender.currentTitle, let url = setUrl(from: label) {
            showTutorial(to: url)
        }
    }
    
    func setUrl(from text: String) -> String? {
        for event in choosenEvents {
            if text == event.name {
                return event.url
            }
        }
        return nil
    }
    
    func showTutorial(to url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}

