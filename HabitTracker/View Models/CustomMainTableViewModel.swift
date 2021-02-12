//
//  CustomMainTableViewModel.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 12.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

struct CustomMainTableListViewModel {
    let habitEntities: [HabitEntity]
}

extension CustomMainTableListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.habitEntities.count
    }
    
    func habitEntityAtIndex(_ index: Int) -> CustomMainTableViewModel {
        let habitEntity = self.habitEntities[index]
        return CustomMainTableViewModel(habitEntity)
    }
}

struct CustomMainTableViewModel {
    private let habitEntity: HabitEntity
}

extension CustomMainTableViewModel {
    init(_ habitEntity: HabitEntity) {
        self.habitEntity = habitEntity
    }
}

extension CustomMainTableViewModel {
    
    var details: String {
        return self.habitEntity.name ?? ""
    }
    
    var counterDescription: String {
        let startDate =  habitEntity.startDate
        let hour =  habitEntity.startHour
        let minute =  habitEntity.startMinute
        let showYears = habitEntity.showYears
        return DateHelper.app.calculateDays(startDate: startDate!, hour: Int(hour), minute: Int(minute), isNotOnlyDays: showYears, showHours: false, hasSuffix:  true)
    }
    
    var image: UIImage? {
        let habitCategory = Int(habitEntity.habitCategory)
        let habitTitle = Int(habitEntity.habitTitle)
        if habitCategory != 0 {
            return UIImage(named: Constants.habitTitlesImages[habitCategory][habitTitle])
        }
        else {
            return UIImage(named: "time.png")
        }
    }
}
