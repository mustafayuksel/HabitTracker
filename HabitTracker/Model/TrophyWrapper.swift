//
//  TrophyGroup.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 16.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation

class TrophyWrapper {
    
    var trophyList = [Trophy]()
    var headerName = ""
    init(trophyList : [Trophy], headerName : String) {
        self.trophyList = trophyList
        self.headerName = headerName
    }
}
