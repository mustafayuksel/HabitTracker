//
//  StoreReviewHelper.swift
//  HabitTracker
//
//  Created by Mustafa on 8.07.2019.
//  Copyright © 2019 Mustafa. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() {
        
        guard var appOpenCount = Constants.Defaults.value(forKey: Constants.Keys.AppCount) as? Int else {
            Constants.Defaults.set(1, forKey: Constants.Keys.AppCount)
            return
        }
        appOpenCount += 1
        Constants.Defaults.set(appOpenCount, forKey: Constants.Keys.AppCount)
    }
    static func checkAndAskForReview() {
        guard let appOpenCount = Constants.Defaults.value(forKey: Constants.Keys.AppCount) as? Int else {
            Constants.Defaults.set(1, forKey: Constants.Keys.AppCount)
            return
        }
        
        switch appOpenCount {
        case 5:
            print(appOpenCount)
            StoreReviewHelper().requestReview()
        case _ where appOpenCount%20 == 0 :
            StoreReviewHelper().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break
        }
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}
