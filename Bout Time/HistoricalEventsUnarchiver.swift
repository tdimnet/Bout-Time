//
//  HistoricalEventsUnarchiver.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 18/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import Foundation

class HistoricalEventsUnarchiver {
    static func historicalEventsInventory(fromDictionary dictionary: [String: AnyObject]) -> [HistoricalEventProtocol] {
        
        var inventory: [HistoricalEventProtocol] = []
        
        for (_, value) in dictionary {
            if let historicalEventDictionary = value as? [String: AnyObject], let date = historicalEventDictionary["date"] as? Int, let name = historicalEventDictionary["name"] as? String, let url = historicalEventDictionary["url"] as? String {
                let historicalEvent = HistoricalEventStruct(name: name, year: date, url: url)
                inventory.append(historicalEvent)
            }
        }
        
        return inventory
    }
}
