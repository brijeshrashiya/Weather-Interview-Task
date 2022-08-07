//
//  StringUtilities.swift
//  Weather Demo
//
//  Created by Brijesh on 05/08/22.
//

import Foundation

class StringUtils: NSObject {
    
    static func countryNameFromLocaleCode(localeCode : String) -> String {
        return NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.countryCode, value: localeCode) ?? ""
    }
}


