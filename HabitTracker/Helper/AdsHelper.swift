//
//  AdsHelper.swift
//  HabitTracker
//
//  Created by Mustafa on 11.04.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct AdsHelper {
    func checkAndAskForAds(uiViewController : UIViewController, unitId : String) {
        let requestIDFAComplete = Constants.Defaults.value(forKey: Constants.Keys.RequestIDFAComplete)
        if requestIDFAComplete == nil {
            Constants.Defaults.set(false, forKey: Constants.Keys.RequestIDFAComplete)
        }
        if requestIDFAComplete as? Bool == true {
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
               // App.showAdmobInterstitial(unitId: unitId)
            }
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView,_ view : UIView) {
        let requestIDFAComplete = Constants.Defaults.value(forKey: Constants.Keys.RequestIDFAComplete)
        if requestIDFAComplete == nil {
            Constants.Defaults.set(false, forKey: Constants.Keys.RequestIDFAComplete)
        }
        if requestIDFAComplete as? Bool == true {
            let removeAds = Constants.Defaults.value(forKey: Constants.Keys.RemoveAds) as? Bool
            if removeAds == false {
          /*     bannerView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(bannerView)
                view.addConstraints(
                    [NSLayoutConstraint(item: bannerView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view.safeAreaLayoutGuide,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0),
                     NSLayoutConstraint(item: bannerView,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: view.safeAreaLayoutGuide,
                                        attribute: .centerX,
                                        multiplier: 1,
                                        constant: 0)
                    ])*/
            }
        }
    }
}
