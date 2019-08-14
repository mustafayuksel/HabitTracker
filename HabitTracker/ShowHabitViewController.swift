//
//  ShowHabitViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class ShowHabitViewController: UIViewController {
    var selectedHabit : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var habitEntityList : [HabitEntity] = []
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var daysCounterLabel: UILabel!
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        let excludeActivities = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.message, UIActivity.ActivityType.mail]
        activityViewController.excludedActivityTypes = excludeActivities
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            activityViewController.popoverPresentationController!.permittedArrowDirections = []
            activityViewController.popoverPresentationController!.sourceView = self.view
            activityViewController.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitEntityList = DatabaseUtil.app.getHabitEntityResults() as! [HabitEntity]
        titleLabel.text = habitEntityList[selectedHabit].name
        icon.image = UIImage(named: Constants.habitTitlesImages[Int(habitEntityList[selectedHabit].habitCategory)][Int(habitEntityList[selectedHabit].habitTitle)])
        daysCounterLabel.text = DateHelper.app.calculateDays(habitEntity: habitEntityList[selectedHabit])
    }
}
