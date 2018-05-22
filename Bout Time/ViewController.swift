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
    var questions: [HistoricalEventStruct] = []
    
    // IB
    
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

    func gameStart() -> Void {
        // Fill in the questions array
        questions = game.questionsDictionary
        displayQuestion()
    }
    
    func displayQuestion() -> Void {
        print("Start displaying questions\n")
        
        var randomSelectedQuestions: [HistoricalEventStruct] = []
        
        print("Questions count: \(questions.count)")
        
        
        for _ in 0..<4 {
            let randomIndex: Int = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
            
            // Adding the 4 questions to the randomSelectedQuestions
            randomSelectedQuestions.append(questions[randomIndex])
            
            // And removing the 4 questions from the questions array
            questions.remove(at: randomIndex)
        }
        
        
        // Display them just to be sure the count has dicreased
        print(randomSelectedQuestions)
        print("Questions count: \(questions.count)")
        
    }
    
    func displayScore() -> Void {
        
    }
    
    func nextRound() -> Void {
        if game.questionsAsked == game.questionsAsked {
            displayScore()
        } else {
            displayQuestion()
        }
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

