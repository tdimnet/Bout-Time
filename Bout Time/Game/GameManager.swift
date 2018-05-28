//
//  GameManager.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 17/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import Foundation

// MARK: - Historical Event Protocol
protocol HistoricalEventProtocol {
    var name: String { get }
    var year: Int { get }
    var url: String { get }
}


// MARK: - Historical Event Struct
struct HistoricalEventStruct: HistoricalEventProtocol {
    let name: String
    let year: Int
    let url: String
}


// MARK: - Game Manager Protocol
protocol GameManagerProtocol {
    var questionsDictionary: [HistoricalEventStruct] { get set }
    
    var gameScore: Int { get set }
    var questionsPerRound: Int { get }
    var questionsAsked: Int { get set }
    
    func checkAnswer(from question: HistoricalEventStruct, with answer: String) -> Bool
    func setIsGameOver(gameScore: Int, timer: Int) -> Bool
}


// MARK: - Game Manager Class
struct GameManager: GameManagerProtocol {
    var questionsDictionary: [HistoricalEventStruct]
    
    var gameScore: Int
    let questionsPerRound: Int
    var questionsAsked: Int
    
    func checkAnswer(from question: HistoricalEventStruct, with answer: String) -> Bool {
        return true
    }
    
    func setIsGameOver(gameScore: Int, timer: Int) -> Bool {
        return true
    }
}
