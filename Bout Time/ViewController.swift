//
//  ViewController.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 14/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game: GameManager
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HistoricalEvents", ofType: "plist")
            guard let inventory: [HistoricalEventStruct] = try HistoricalEventsUnarchiver.historicalEventsInventory(fromDictionary: dictionary) as? [HistoricalEventStruct] else {
                // FIXME: Add a better work for the inventory
                fatalError()
            }
            self.game = GameManager(dictionary: inventory)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(game.questionsDictionary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

