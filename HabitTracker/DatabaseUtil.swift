//
//  DatabaseUtil.swift
//  HabitTracker
//
//  Created by Mustafa on 10.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseUtil{
    static var app: DatabaseUtil = {
        return DatabaseUtil()
    }()
    
    func getThemeEntityResults() -> [HabitEntity?] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
        request.returnsObjectsAsFaults = false
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let results = try context.fetch(request)
            if(!results.isEmpty){
                return try ((context.fetch(request) as? [HabitEntity])!)
            }
        }catch{
            print("error")
        }
        return []
    }
    
    func insertThemeEntity(data : HabitEntity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: Constants.HABIT_ENTITY, into: context)
        entity.setValue(data.habitCategory, forKey: "habitCategory")
        entity.setValue(data.habitTitle, forKey: "habitTitle")
        entity.setValue(data.name, forKey: "name")
        entity.setValue(data.reminderFrequency, forKey: "reminderFrequency")
        entity.setValue(data.startDate, forKey: "startDate")
        entity.setValue(data.startTime, forKey: "startTime")
        
        do{
            try context.save()
            print("no error")
        }catch{
            print("error")
        }
    }
    
    func saveThemeEntityAttribute(index : Int, attributeName : String, data : Any){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
        request.returnsObjectsAsFaults = false
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let results = try context.fetch(request)
            let entity = results[index] as! HabitEntity
            entity.setValue(data, forKey: attributeName)
            do{
                try context.save()
                print("no error")
            }catch{
                print("error")
            }
        }catch{
            print("error")
        }
    }
}
