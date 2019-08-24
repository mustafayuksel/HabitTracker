//
//  ViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 26.07.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    static var app: NotificationHelper = {
        return NotificationHelper()
    }()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func userRequest() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(title : String, body : String, frequency : ReminderFrequency, identifier : String) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        let hour = 13
        let minute = 0
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        var dateComponent : DateComponents? = nil
        switch frequency {
        case ReminderFrequency.DAILY:
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            dateComponent = Calendar.current.dateComponents([.day,.hour,.minute,.second,], from: tomorrow!)
            break
        case ReminderFrequency.WEEKLY:
            dateComponent = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: Date())
            break
        case ReminderFrequency.MONTLY:
            dateComponent = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second,], from: Date())
            break
        case ReminderFrequency.YEARLY:
            dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: Date())
            break
        default:
            return
        }
        if dateComponent != nil {
            dateComponent?.hour = hour
            dateComponent?.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent!, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
            
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: userActions,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            
            notificationCenter.setNotificationCategories([category])
        }
    }
    
    func unscheduleNotification(identifiers : [String]){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    /*func userNotificationCenter(_ center: UNUserNotificationCenter,
     willPresent notification: UNNotification,
     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     
     completionHandler([.alert,.sound])
     }
     
     func userNotificationCenter(_ center: UNUserNotificationCenter,
     didReceive response: UNNotificationResponse,
     withCompletionHandler completionHandler: @escaping () -> Void) {
     
     if response.notification.request.identifier == "Local Notification" {
     print("Handling notifications with the Local Notification Identifier")
     }
     
     switch response.actionIdentifier {
     case UNNotificationDismissActionIdentifier:
     print("Dismiss Action")
     case UNNotificationDefaultActionIdentifier:
     print("Default")
     case "Snooze":
     print("Snooze")
     scheduleNotification(notificationType: "sdfd")
     case "Delete":
     print("Delete")
     default:
     print("Unknown action")
     }
     completionHandler()
     }*/
}
