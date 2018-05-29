//
//  PlistConverter.swift
//  Bout Time
//
//  Created by Thomas Dimnet on 17/05/2018.
//  Copyright © 2018 Thomas Dimnet. All rights reserved.
//

import Foundation

enum ConverterErrorHandling: Error {
    case invalidRessource
    case conversionFailure
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw ConverterErrorHandling.invalidRessource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw ConverterErrorHandling.conversionFailure
        }
        
        return dictionary
    }
}
