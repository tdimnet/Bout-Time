//
//  Timer.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 28/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import Foundation

// MARK: - Timer Protocol
protocol TimerProtocol {
    var timerIsOn: Bool { get set }
    var timer: Timer { get set }
    var timeRemaining: Int { get set }
    var totalTime: Int { get set }
}

struct TimerManager: TimerProtocol {
    var timerIsOn: Bool
    var timer: Timer
    var timeRemaining: Int
    var totalTime: Int
}

