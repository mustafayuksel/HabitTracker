//
//  CoreDataStack.swift
//  HabitTrackerWidget
//
//  Created by Mustafa on 14.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HabitTracker")
        
        let appName: String = "xx"
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let storeUrl =  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.habittrackercounter")!.appendingPathComponent("HabitTracker.xcdatamodeld")
        
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url:  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.habittrackercounter")!.appendingPathComponent("HabitTracker.xcdatamodeld"))]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
