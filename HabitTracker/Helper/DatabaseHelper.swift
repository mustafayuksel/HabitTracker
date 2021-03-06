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

class DatabaseHelper {
    static var app: DatabaseHelper = {
        return DatabaseHelper()
    }()
    
    func getHabitEntityResults() -> [HabitEntity?] {
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
    
    func insertHabitEntity(data : Habit) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: Constants.HABIT_ENTITY, into: context)
        entity.setValue(data.habitCategory, forKey: "habitCategory")
        entity.setValue(data.habitTitle, forKey: "habitTitle")
        entity.setValue(data.name, forKey: "name")
        entity.setValue(data.reminderFrequency, forKey: "reminderFrequency")
        entity.setValue(data.startDate, forKey: "startDate")
        entity.setValue(data.startHour, forKey: "startHour")
        entity.setValue(data.startMinute, forKey: "startMinute")
        entity.setValue(data.isPrimary, forKey: "isPrimary")
        entity.setValue(data.notificationId, forKey: "notificationId")
        entity.setValue(data.showYears, forKey: "showYears")
        entity.setValue(data.showHours, forKey: "showHours")
        entity.setValue(data.trophyIndex, forKey: "trophyIndex")
        entity.setValue(data.trophySectionIndex, forKey: "trophySectionIndex")
        do{
            try context.save()
            print("no error")
        }catch{
            print("error")
        }
    }
    
    func saveHabitEntityAttribute(index : Int, attributeName : String, data : Any){
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
    
    func deleteHabitEntity(index : Int){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
        request.returnsObjectsAsFaults = false
        do{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let resultList = try context.fetch(request)
            let objectToDelete = resultList[index] as! NSManagedObject
            context.delete(objectToDelete)
            do{
                try context.save()
            }
            catch{
                print("error")
            }
        }catch{
            print("error")
        }
    }
    
    func updateData(index : Int, habit : Habit){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
        request.returnsObjectsAsFaults = false
        do {
            let resultList = try context.fetch(request)
            let objectToUpdate = resultList[index] as! NSManagedObject
            objectToUpdate.setValue(habit.name, forKey: "name")
            objectToUpdate.setValue(habit.reminderFrequency, forKey: "reminderFrequency")
            objectToUpdate.setValue(habit.startDate, forKey: "startDate")
            objectToUpdate.setValue(habit.startHour, forKey: "startHour")
            objectToUpdate.setValue(habit.startMinute, forKey: "startMinute")
            objectToUpdate.setValue(habit.isPrimary, forKey: "isPrimary")
            objectToUpdate.setValue(habit.showYears, forKey: "showYears")
            objectToUpdate.setValue(habit.showHours, forKey: "showHours")
            objectToUpdate.setValue(habit.trophyIndex, forKey: "trophyIndex")
            objectToUpdate.setValue(habit.trophySectionIndex, forKey: "trophySectionIndex")
            objectToUpdate.setValue(habit.trophyInnerSectionIndex, forKey: "trophyInnerSectionIndex")
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    func updateTrophyData(index : Int, trophyParts : (index: Int, sectionIndex: Int, innerSectionIndex : Int)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
        request.returnsObjectsAsFaults = false
        
        do {
            let resultList = try context.fetch(request)
            let objectToUpdate = resultList[index] as! NSManagedObject
            objectToUpdate.setValue(trophyParts.index, forKey: "trophyIndex")
            objectToUpdate.setValue(trophyParts.sectionIndex, forKey: "trophySectionIndex")
            objectToUpdate.setValue(trophyParts.innerSectionIndex, forKey: "trophyInnerSectionIndex")
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
}
