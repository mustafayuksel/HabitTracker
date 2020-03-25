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
    
    fileprivate func setHours(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        if differenceOfDate.hour ?? 0 > 0 {
            if let hourText: String = String(describing: differenceOfDate.hour ?? 0) {
                if differenceOfDate.hour ?? 0 > 1 {
                    let systemLanguage = Locale.current.languageCode
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
        }
        if differenceOfDate.minute ?? 0 > 0 {
            if let minuteText: String = String(describing: differenceOfDate.minute ?? 0) {
                if differenceOfDate.minute ?? 0 > 1 {
                    let systemLanguage = Locale.current.languageCode
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
    }
    
    fileprivate func setDays(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        if let dayText: String = String(describing: differenceOfDate.day ?? 0) {
            if differenceOfDate.day ?? 0 > 1 {
                let systemLanguage = Locale.current.languageCode
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
    }
    
    fileprivate func setYears(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        if let dayText: String = String(describing: differenceOfDate.year ?? 0) {
            if differenceOfDate.year ?? 0 > 1 {
                let systemLanguage = Locale.current.languageCode
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
    }
    
    fileprivate func setMonths(_ differenceOfDate: DateComponents, _ counterText: inout String) {
        if let dayText: String = String(describing: differenceOfDate.month ?? 0) {
            if differenceOfDate.month ?? 0 > 1 {
                let systemLanguage = Locale.current.languageCode
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
    }
    
    func calculateDays (startDate : String, hour : Int, minute : Int, isNotOnlyDays : Bool, showHours : Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let selectedDate = dateFormatter.date(from:startDate)!
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: Int(hour), minute: Int(minute), second: 0, of: selectedDate)!
        
        let date1 = calendar.startOfDay(for: date)
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
        counterText += NSLocalizedString("Passed", comment: "")
        return counterText
    }
}
