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
}

// MARK: - Historical Event Struct
struct HistoricalEventStruct: HistoricalEventProtocol {
    let name: String
    let year: Int
}


// MARK: - Game Manager Protocol
protocol GameManagerProtocol {
    var questionsDictionary: [HistoricalEventStruct] { get }
    var gameScore: Int { get set }
    var timer: Int { get set }
    
    func checkAnswer(from question: HistoricalEventStruct, with answer: String) -> Bool
    func setIsGameOver(gameScore: Int, timer: Int) -> Bool
}
