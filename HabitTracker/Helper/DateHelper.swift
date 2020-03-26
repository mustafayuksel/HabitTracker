//
//  DateUtil.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation

class DateHelper {
    static var app: DateHelper = {
        return DateHelper()
    }()
    
    private let systemLanguage = Locale.current.languageCode
    
    fileprivate func setHours(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        if differenceOfDate.hour ?? 0 > 0 {
            let hourText = String(describing: differenceOfDate.hour ?? 0)
            if differenceOfDate.hour ?? 0 > 1 {
                if systemLanguage != "tr" {
                    counterText += hourText + " " + NSLocalizedString("Hours", comment: "") + " "
                }
                else {
                    counterText += hourText + " " + NSLocalizedString("Hour", comment: "") + " "
                }
            }
            else {
                counterText += hourText + " " + NSLocalizedString("Hour", comment: "") + " "
            }
        }
        
        if differenceOfDate.minute ?? 0 > 0 {
            let minuteText = String(differenceOfDate.minute ?? 0)
            if differenceOfDate.minute ?? 0 > 1 {
                if systemLanguage != "tr" {
                    counterText += minuteText + " " + NSLocalizedString("Minutes", comment: "") + " "
                }
                else {
                    counterText += minuteText + " " + NSLocalizedString("Minute", comment: "") + " "
                }
            }
            else {
                counterText += minuteText + " " + NSLocalizedString("Minute", comment: "") + " "
            }
        }
    }
    
    fileprivate func setDays(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        let dayText = String(differenceOfDate.day ?? 0)
        if differenceOfDate.day ?? 0 > 1 {
            if systemLanguage != "tr" {
                counterText += dayText + " " + NSLocalizedString("Days", comment: "") + " "
            }
            else {
                counterText += dayText + " " + NSLocalizedString("Day", comment: "") + " "
            }
        }
        else {
            counterText += dayText + " " + NSLocalizedString("Day", comment: "") + " "
        }
    }
    
    
    fileprivate func setYears(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        let dayText = String( differenceOfDate.year ?? 0)
        if differenceOfDate.year ?? 0 > 1 {
            if systemLanguage != "tr" {
                counterText = dayText + " " + NSLocalizedString("Years", comment: "") + " "
            }
            else {
                counterText = dayText + " " + NSLocalizedString("Year", comment: "") + " "
            }
        }
        else {
            counterText = dayText + " " + NSLocalizedString("Year", comment: "") + " "
        }
        
    }
    
    fileprivate func setMonths(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        let dayText = String( differenceOfDate.month ?? 0)
        if differenceOfDate.month ?? 0 > 1 {
            if systemLanguage != "tr" {
                counterText += dayText + " " + NSLocalizedString("Months", comment: "") + " "
            }
            else {
                counterText += dayText + " " + NSLocalizedString("Month", comment: "") + " "
            }
        }
        else {
            counterText += dayText + " " + NSLocalizedString("Month", comment: "") + " "
        }
        
    }
    
    func calculateDays (startDate : String, hour : Int, minute : Int, isNotOnlyDays : Bool, showHours : Bool, hasSuffix : Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let selectedDate = dateFormatter.date(from:startDate)!
        let calendar = Calendar.current
        let date1 = calendar.date(bySettingHour: Int(hour), minute: Int(minute), second: 0, of: selectedDate)!
        let date2 = Date()
        
        var counterText = ""
        if isNotOnlyDays {
            let components = Set<Calendar.Component>([.minute, .hour, .day, .month, .year])
            let differenceOfDate = calendar.dateComponents(components, from: date1, to: date2)
            if differenceOfDate.year ?? 0 > 0 {
                setYears(differenceOfDate, &counterText)
            }
            if differenceOfDate.month ?? 0 > 0 {
                setMonths(differenceOfDate, &counterText)
            }
            if differenceOfDate.day ?? 0 > 0 {
                setDays(differenceOfDate, &counterText)
            }
            if showHours || counterText.isEmpty {
                setHours(differenceOfDate, &counterText)
            }
        }
        else {
            let components = Set<Calendar.Component>([.day, .hour, .minute])
            let differenceOfDate = calendar.dateComponents(components, from: date1, to: date2)
            if differenceOfDate.day ?? 0 > 0 {
                setDays(differenceOfDate, &counterText)
            }
            if showHours || counterText.isEmpty {
                setHours(differenceOfDate, &counterText)
            }
        }
        if counterText.isEmpty {
            if systemLanguage != "tr" {
                counterText += "0 " + NSLocalizedString("Days", comment: "") + " "
            }
            else {
                counterText += "0 " + NSLocalizedString("Day", comment: "") + " "
            }
        }
        
        if hasSuffix {
            counterText += NSLocalizedString("Passed", comment: "")
        }
        
        return counterText
    }
    
    static func selectedDateToFormattedString(startDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let startDate = dateFormatter.date(from: startDate)
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd MMMM yyyy"
        return dateformat.string(from: startDate!)
    }
    
    fileprivate func calculateDifferenceOfDate(startDate : String, components : Set<Calendar.Component>) -> DateComponents{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:startDate)!
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: date)
        let date2 = Date()
        return calendar.dateComponents(components, from: date1, to: date2)
    }
    
    func calculatePassedByDateComponent(startDate : String, dateComponent : Calendar.Component) -> String? {
        var counterText = ""
        let systemLanguage = Locale.current.languageCode
        
        let differenceOfDate =  calculateDifferenceOfDate(startDate: startDate, components: Set<Calendar.Component>([dateComponent]))
        
        var differenceOfDateComponent = 0
        
        var timeLocalizable = ""
        
        switch dateComponent {
        case Calendar.Component.year:
            differenceOfDateComponent = differenceOfDate.year ?? 0
            timeLocalizable = "Year"
        case Calendar.Component.month:
            differenceOfDateComponent = differenceOfDate.month ?? 0
            timeLocalizable = "Month"
        case Calendar.Component.day:
            differenceOfDateComponent = differenceOfDate.day ?? 0
            timeLocalizable = "Day"
        case Calendar.Component.hour:
            differenceOfDateComponent = differenceOfDate.hour ?? 0
            timeLocalizable = "Hour"
        case Calendar.Component.minute:
            differenceOfDateComponent = differenceOfDate.minute ?? 0
            timeLocalizable = "Minute"
        case Calendar.Component.second:
            differenceOfDateComponent = differenceOfDate.second ?? 0
            timeLocalizable = "Second"
        default:
            differenceOfDateComponent = 0
        }
        
        if differenceOfDateComponent > 0 {
            let dateText = String(differenceOfDateComponent)
            
            if systemLanguage != "tr" {
                if differenceOfDateComponent == 1 {
                    counterText = counterText + dateText + " " + NSLocalizedString(timeLocalizable, comment: "") + " " + NSLocalizedString("Passed", comment: "")
                }
                else {
                    counterText = counterText + dateText + " " + NSLocalizedString(timeLocalizable + "s", comment: "") + " " + NSLocalizedString("Passed", comment: "")
                }
            }
            else{
                counterText = counterText + dateText + " " + NSLocalizedString(timeLocalizable, comment: "") + " " + NSLocalizedString("Passed", comment: "")
            }
        }
        else {
            counterText = "0 " + NSLocalizedString(timeLocalizable, comment: "") + " " + NSLocalizedString("Passed", comment: "")
        }
        return counterText
    }
}
