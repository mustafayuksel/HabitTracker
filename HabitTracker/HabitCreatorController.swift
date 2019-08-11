//
//  HabitCreatorController.swift
//  HabitTracker
//
//  Created by Mustafa on 8.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class HabitCreatorController: UIViewController{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reminderFrequencyLabel: UILabel!
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderFrequencySegmented: UISegmentedControl!
    
     var selectedCategory : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedCategory) as! Int
     var selectedTitle : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedTitle) as! Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        habitNameTextField.text = NSLocalizedString(Constants.habitTitles[selectedCategory][selectedTitle], comment: "")
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        //reminderFrequencySegmented.selectedSegmentIndex
        var habitEntity = Habit(name: "Test", habitCategory: selectedCategory, habitTitle: selectedTitle, reminderFrequency: 1, startDate: Date(timeIntervalSinceNow: 1200), startTime: Date(timeIntervalSinceNow: 1200))
        DatabaseUtil.app.insertHabitEntity(data: habitEntity)
    }
}
