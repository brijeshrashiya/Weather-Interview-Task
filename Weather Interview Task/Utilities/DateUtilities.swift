//
//  DateUtilities.swift
//  Weather Demo
//
//  Created by Brijesh on 04/08/22.
//

import UIKit

class DateUtilities: NSObject {
    
    //MARK: Constant
    
    static var formatter: DateFormatter { return DateFormatter() }
    
    struct DateFormates {
        static let kOnlyTime = "hh:mm a"
    }
    
    static func dateFromTimeStamp(timestamp:Double) -> String {
        if timestamp > 0.0{
            
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormates.kOnlyTime
            return dateFormatter.string(from: date)
        }
        return "-"
    }
}
