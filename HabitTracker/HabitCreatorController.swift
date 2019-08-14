//
//  HabitCreatorController.swift
//  HabitTracker
//
//  Created by Mustafa on 8.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class HabitCreatorController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reminderFrequencyLabel: UILabel!
    @IBOutlet weak var habitNameTextField: UITextField!
    
    @IBOutlet var saveButtonLabel: UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderFrequencySegmented: UISegmentedControl!
    
    var selectedCategory : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedCategory) as! Int
    var selectedTitle : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedTitle) as! Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = NSLocalizedString("Date", comment: "")
        timeLabel.text = NSLocalizedString("Time", comment: "")
        reminderFrequencyLabel.text = NSLocalizedString("ReminderFrequency", comment: "")
        saveButtonLabel.title = NSLocalizedString("Save", comment: "")
        reminderFrequencySegmented.setTitle(NSLocalizedString("Daily", comment: ""), forSegmentAt: 0)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Weekly", comment: ""), forSegmentAt: 1)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Monthly", comment: ""), forSegmentAt: 2)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Yearly", comment: ""), forSegmentAt: 3)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Never", comment: ""), forSegmentAt: 4)
        
        habitNameTextField.text = NSLocalizedString(Constants.habitTitles[selectedCategory][selectedTitle], comment: "")
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedStartDate = formatter.string(from: datePicker.date)
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = components.hour!
        let minute = components.minute!
        let habitEntity = Habit(name: habitNameTextField.text ?? "", habitCategory: selectedCategory, habitTitle: selectedTitle, reminderFrequency: reminderFrequencySegmented.selectedSegmentIndex, startDate: formattedStartDate, startHour: hour, startMinute : minute)
        DatabaseUtil.app.insertHabitEntity(data: habitEntity)
        ViewController.isSaveButtonClick = true
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
}
