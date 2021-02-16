//
//  TrophyViewControllerHelper.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 17.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class TrophyViewControllerHelper {
    
    func prepareTrophyObject() -> [TrophyWrapper] {
        var trophyObject = [TrophyWrapper]()
        var trophySection1 = [Trophy]()
        
        let clearImage = UIImage(color: AppDelegate.UIColorFromHex(rgbValue: 0xE5E5E5))
        trophySection1.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 1", description2: NSLocalizedString("Day", comment: "") + " 2", image1: UIImage.init(named: "bronze1.png")!, image2: UIImage.init(named: "bronze2.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection1.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 3", description2: NSLocalizedString("Day", comment: "") + " 4", image1: UIImage.init(named: "bronze3.png")!, image2: UIImage.init(named: "bronze4.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection1.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 5", description2: NSLocalizedString("Day", comment: "") + " 6", image1: UIImage.init(named: "bronze5.png")!, image2: UIImage.init(named: "bronze6.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        var trophySection2 = [Trophy]()
        trophySection2.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 7", description2: NSLocalizedString("Day", comment: "") + " 10", image1: UIImage.init(named: "silver1.png")!, image2: UIImage.init(named: "silver2.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection2.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 15", description2: NSLocalizedString("Day", comment: "") + " 20", image1: UIImage.init(named: "silver3.png")!, image2: UIImage.init(named: "silver4.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection2.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 25", description2: NSLocalizedString("Day", comment: "") + " 30", image1: UIImage.init(named: "silver5.png")!, image2: UIImage.init(named: "silver6.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection2.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 40", description2: NSLocalizedString("Day", comment: "") + " 50", image1: UIImage.init(named: "silver7.png")!, image2: UIImage.init(named: "silver8.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection2.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 60", description2: NSLocalizedString("Day", comment: "") + " 75", image1: UIImage.init(named: "silver9.png")!, image2: UIImage.init(named: "silver10.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        var trophySection3 = [Trophy]()
        trophySection3.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 90", description2: NSLocalizedString("Day", comment: "") + " 120", image1: UIImage.init(named: "gold1.png")!, image2: UIImage.init(named: "gold2.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection3.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 150", description2: NSLocalizedString("Day", comment: "") + " 180", image1: UIImage.init(named: "gold3.png")!, image2: UIImage.init(named: "gold4.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection3.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 210", description2: NSLocalizedString("Day", comment: "") + " 240", image1: UIImage.init(named: "gold5.png")!, image2: UIImage.init(named: "gold6.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection3.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 270", description2: NSLocalizedString("Day", comment: "") + " 300", image1: UIImage.init(named: "gold7.png")!, image2: UIImage.init(named: "gold8.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        trophySection3.append(Trophy(description1: NSLocalizedString("Day", comment: "") + " 330", description2: NSLocalizedString("Day", comment: "") + " 365", image1: UIImage.init(named: "gold9.png")!, image2: UIImage.init(named: "gold10.png")!, backgroundImage1 : clearImage!, backgroundImage2 : clearImage!))
        
        trophyObject.append(TrophyWrapper(trophyList: trophySection1, headerName: NSLocalizedString("Bronze", comment: "") + " " + NSLocalizedString("Series", comment: "")))
        trophyObject.append(TrophyWrapper(trophyList: trophySection2, headerName: NSLocalizedString("Silver", comment: "") + " " + NSLocalizedString("Series", comment: "")))
        trophyObject.append(TrophyWrapper(trophyList: trophySection3, headerName: NSLocalizedString("Gold", comment: "") + " " + NSLocalizedString("Series", comment: "")))
        return trophyObject
    }
}
