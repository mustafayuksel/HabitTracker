//
//  CustomTrophyTableViewModel.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 16.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

struct CustomTrophyListTableViewModel {
    let trophies: [TrophyWrapper]
}

extension CustomTrophyListTableViewModel {
    
    var numberOfSections: Int {
        return trophies.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.trophies[section].trophyList.count
    }
    
    func trophyAtIndex(_ section: Int, _ index: Int) -> CustomTrophyTableViewModel {
        let trophy = self.trophies[section].trophyList[index]
        return CustomTrophyTableViewModel(trophy)
    }
}

struct CustomTrophyTableViewModel {
    private let trophy: Trophy
}

extension CustomTrophyTableViewModel {
    init(_ trophy: Trophy) {
        self.trophy = trophy
    }
}

extension CustomTrophyTableViewModel {
    
    var description1: String {
        return self.trophy.description1
    }
    
    var image1: UIImage {
        return self.trophy.image1
    }
    
    var description2: String {
        return self.trophy.description2
    }
    
    var image2: UIImage {
        return self.trophy.image2
    }
    
    var backgroundImage1: UIImage {
        return self.trophy.backgroundImage1
    }
    
    var backgroundImage2: UIImage {
        return self.trophy.backgroundImage2
    }
}
