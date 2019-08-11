//
//  Habit.swift
//  HabitTracker
//
//  Created by Mustafa on 11.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class Habit {
    let name : String
    let habitCategory : Int
    let habitTitle : Int
    let reminderFrequency : Int
    let startDate : Date
    let startTime : Date
    
    init(name: String, habitCategory : Int, habitTitle : Int, reminderFrequency : Int, startDate : Date, startTime : Date) {
        self.name = name
        self.habitCategory = habitCategory
        self.habitTitle = habitTitle
        self.reminderFrequency = reminderFrequency
        self.startDate = startDate
        self.startTime = startTime
    }
}
