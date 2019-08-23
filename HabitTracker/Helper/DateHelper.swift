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
    
    func calculateDays (startDate : String, hour : Int, minute : Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let formattedStartDate = dateFormatter.date(from:startDate)!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT+0:00")!
        let selectedDate = calendar.date(bySettingHour: Int(hour), minute: Int(minute), second: 0, of: formattedStartDate)!
        let currentDate = Date()
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = currentDate.timeIntervalSince1970
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        let component = Set<Calendar.Component>([.day])
        let differenceOfDate = calendar.dateComponents(component, from: selectedDate, to: timeZoneOffsetDate)
        if let dayText: String = String(describing: differenceOfDate.day ?? 0) {
            if differenceOfDate.day ?? 0 > 1 {
                let systemLanguage = Locale.current.languageCode
                if systemLanguage != "tr" {
                    return dayText + " " + NSLocalizedString("Days", comment: "")
                }
                else {
                    return dayText + " " + NSLocalizedString("Day", comment: "")
                }
            }
            else {
                return dayText + " " + NSLocalizedString("Day", comment: "")
            }
        }
        return "0 " + NSLocalizedString("Day", comment: "")
    }
}
