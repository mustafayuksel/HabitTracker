//
//  TodayViewController.swift
//  HabitTrackerWidget
//
//  Created by Mustafa on 14.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var habitLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        prepareWidget()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myAppUrl = NSURL(string: "habittracker://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                print("error")            }
        })
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        prepareWidget()
        completionHandler(NCUpdateResult.newData)
    }
    func prepareWidget(){
        let coreDataStack = CoreDataStack()
        let context  = coreDataStack.getContext()
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.HABIT_ENTITY)
            let results = try context.fetch(request)
            print(results.count)
            
            if results.count > 0 {
                
                for item in results as! [NSManagedObject] {
                    let isPrimary = item.value(forKey: "isPrimary") as! Bool
                    if isPrimary {
                        let detailsText = item.value(forKey: "name")
                        let habitCategory = item.value(forKey: "habitCategory") as! Int
                        let habitTitle = item.value(forKey: "habitTitle") as! Int
                        let startDate = item.value(forKey: "startDate") as! String
                        let startHour = item.value(forKey: "startHour") as! Int
                        let startMinute = item.value(forKey: "startMinute") as! Int
                        if detailsText != nil {
                            habitLabel.text = detailsText as? String
                        }
                        counterLabel.text = DateHelper.app.calculateDays(startDate: startDate, hour: Int(startHour), minute: Int(startMinute))
                        imageView.image = UIImage(named: Constants.habitTitlesImages[habitCategory][habitTitle])
                        break
                    }
                }
            }
        } catch {
            print("there is an error for saving")
        }
    }
}
