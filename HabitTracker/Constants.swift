//
//  Constants.swift
//  HabitTracker
//
//  Created by Mustafa on 10.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let Defaults = UserDefaults.standard
    
    static let habitCategories = ["Write my own", "Quit", "Form a Habit", "Celebrate", "Commit"]
    
    static let habitCategoryImages = ["update.png", "no-smoke.png", "tea-cup.png", "confetti.png", "calendar.png"]
    
    static let habitTitles = [[], ["Caffeine", "Junk Food", "Social Media", "Gaming", "Alcohol", "Smoking", "Addiction", "Swearing", "Gambling"], ["Exercise", "Meditate", "Diet", "Reading", "Wake up", "Hobby"], ["Relationship", "Marriage","Birth", "Retirement", "New Beginning"], ["Play Instrument", "Sing", "Draw", "Practice", "Pray", "Save Money", "Try New Thing", "Call Friend"]]
    
    static let habitTitlesImages = [[], ["coffee-cup.png", "hamburger.png", "network.png", "game-controller.png", "no-alcohol.png", "no-smoke.png", "chained.png", "profanity.png", "poker-cards.png"], ["exercise.png", "yoga.png", "diet.png", "open-book.png", "wake-up.png", "jigsaw.png"], ["relationship.png", "marriage.png","stork.png", "pension.png", "new.png"], ["piano.png", "microphone.png", "edit.png", "best-practice.png", "pray.png", "purse.png", "new.png", "call.png"]]
    
    static let HABIT_ENTITY = "HabitEntity"
    static let PRUDUCT_ID: NSString = "com.mustafayuksel.HabitTracker.removeAds"
    
    static let TROPHY_DAYS = [[[1, 2], [3, 4], [5, 6]], [[7, 10], [15, 20], [25, 30], [40, 50] ,[60, 75]], [[90, 120], [150, 180], [210, 240], [270, 300], [330, 365]]]
    
    static let MAIL_ADDRESS = "habitdaycounter@gmail.com"
    
    static let notificationServerUrl = "https://notification-server-prod.herokuapp.com/"
    
    struct Keys {
        static let SelectedCategory = "selectedCategory"
        static let SelectedTitle = "selectedTitle"
        static let SelectedHabit = "selectedHabit"
        static let RemoveAds = "removeAds"
        static let AppCount = "appCount"
        static let UserId = "userId"
        static let RequestIDFAComplete = "RequestIDFAComplete"
    }
}
