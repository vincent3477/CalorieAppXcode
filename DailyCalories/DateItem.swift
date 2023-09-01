//
//  DateItem.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/28/23.
//

import Foundation

class DateItem{
    let prev_date: Date
    let total_calorie: Int
    
    init(prev_date: Date, total_calorie: Int) {
        self.prev_date = prev_date
        self.total_calorie = total_calorie
    }
}
