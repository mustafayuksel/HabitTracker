//
//  SettingsObject.swift
//  HabitTracker
//
//  Created by Mustafa on 14.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation

class SettingsObject {
    
    var settingsList = [String]()
    var headerName = ""
    init(settingsList : [String], headerName : String) {
        self.settingsList = settingsList
        self.headerName = headerName
    }
}
