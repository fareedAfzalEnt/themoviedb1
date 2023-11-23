//
//  Extensions.swift
//  themoviedb
//
//  Created by Farid Afzal on 22/11/2023.
//

import Foundation
import SwiftUI

extension String {
    
    var toDate : Date {
        let dateString : String = self
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:dateString) ?? Date()
        return date
    }
    
    
    func getYearFromDate(_ date:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let year = myCalendar.component(.year, from: todayDate)
        return "\(year)"
    }
}

