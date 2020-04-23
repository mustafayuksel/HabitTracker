//
//  AdsHelper.swift
//  HabitTracker
//
//  Created by Mustafa on 11.04.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import UIKit

struct AdsHelper {
    static func checkAndAskForAds(uiViewController : UIViewController) {
        guard let appOpenCount = Constants.Defaults.value(forKey: Constants.Keys.AppCount) as? Int else {
            Constants.Defaults.set(1, forKey: Constants.Keys.AppCount)
            return
        }
        let removeAds = Constants.Defaults.value(forKey: Constants.Keys.RemoveAds) as? Bool
        
        if removeAds == true {
            return
        }
        switch appOpenCount {
        case 1..<1:
            print("App run count is : \(appOpenCount)")
        default:
            let App = UIApplication.shared.delegate as! AppDelegate
            App.gViewController = uiViewController
            App.showAdmobInterstitial()
        }
    }
}
