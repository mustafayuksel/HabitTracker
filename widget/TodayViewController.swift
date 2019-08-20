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
                    let detailsText = item.value(forKey: "name")
                    if detailsText != nil {
                        habitLabel.text = detailsText as? String
                        break
                    }
                }
            }
        } catch {
            print("there is an error for saving")
        }
    }
}
