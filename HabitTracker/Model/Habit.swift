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
    public private(set) var name : String
    public private(set) var habitCategory : Int
    public private(set) var habitTitle : Int
    public private(set) var reminderFrequency : Int
    public private(set) var startDate : String
    public private(set) var startHour : Int
    public private(set) var startMinute : Int
    public private(set) var isPrimary : Bool
    public private(set) var showYears : Bool
    public private(set) var showHours : Bool
    public private(set) var notificationId : UUID
    
    init(name: String, habitCategory : Int, habitTitle : Int, reminderFrequency : Int, startDate : String, startHour : Int, startMinute : Int, isPrimary : Bool, notificationId : UUID, showYears : Bool, showHours : Bool) {
        self.name = name
        self.habitCategory = habitCategory
        self.habitTitle = habitTitle
        self.reminderFrequency = reminderFrequency
        self.startDate = startDate
        self.startHour = startHour
        self.startMinute = startMinute
        self.isPrimary = isPrimary
        self.notificationId = notificationId
        self.showYears = showYears
        self.showHours = showHours
    }
}
