//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Mustafa on 26.07.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import OneSignal
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADFullScreenContentDelegate {
    
    var window: UIWindow?
    var mInterstitial: GADInterstitialAd!
    var gViewController: UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationBarAppearace = UINavigationBar.appearance()
        //navigationBarAppearace.tintColor = UIColorFromHex(rgbValue: 0xffffff)
        navigationBarAppearace.barTintColor = AppDelegate.UIColorFromHex(rgbValue: 0x0866c2)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        StoreReviewHelper.incrementAppOpenedCount()
        
        OneSignal.initWithLaunchOptions(launchOptions)
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.setAppId("ecc8009c-1e95-4966-9b68-916538139fee")
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        return true
    }
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func showAdmobInterstitial(unitId : String)
    {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:unitId,
                                        request: request,
                              completionHandler: { (ad, error) in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                self.mInterstitial = ad
                                self.mInterstitial.fullScreenContentDelegate = self
                                ad?.present(fromRootViewController: self.gViewController!)
                              }
            )
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HabitTracker")
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let storeUrl =  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.habittracker")!.appendingPathComponent("HabitTracker.xcdatamodeld")
        
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url:  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.habittracker")!.appendingPathComponent("HabitTracker.xcdatamodeld"))]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
