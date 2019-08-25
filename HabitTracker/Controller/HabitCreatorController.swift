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
    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderFrequencySegmented: UISegmentedControl!
    @IBOutlet var switchOutlet: UISwitch!
    @IBAction func widgetInfoButtonAction(_ sender: Any) {
        let width = self.view.frame.size.width
        let toastLabel = UILabel(frame: CGRect(x: width - 300 - ((width - 300)/2), y: self.view.frame.size.height/2, width: 300, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        //toastLabel.
        toastLabel.textAlignment = .center;
        toastLabel.text = NSLocalizedString("WidgetInfoMessage", comment: "")
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    var selectedCategory : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedCategory) as! Int
    var selectedTitle : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedTitle) as? Int ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = NSLocalizedString("Date", comment: "")
        timeLabel.text = NSLocalizedString("Time", comment: "")
        switchLabel.text =  NSLocalizedString("SetPrimaryForWidget", comment: "")
        reminderFrequencyLabel.text = NSLocalizedString("ReminderFrequency", comment: "")
        saveButtonLabel.title = NSLocalizedString("Save", comment: "")
        reminderFrequencySegmented.setTitle(NSLocalizedString("Daily", comment: ""), forSegmentAt: 0)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Weekly", comment: ""), forSegmentAt: 1)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Monthly", comment: ""), forSegmentAt: 2)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Yearly", comment: ""), forSegmentAt: 3)
        reminderFrequencySegmented.setTitle(NSLocalizedString("Never", comment: ""), forSegmentAt: 4)
        if selectedCategory != 0 {
            habitNameTextField.text = NSLocalizedString(Constants.habitTitles[selectedCategory][selectedTitle], comment: "")
        }
        else {
            habitNameTextField.text = ""
        }
        let habitEntities = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
        
        if habitEntities.isEmpty {
            switchOutlet.isOn = true
        }
        else {
            switchOutlet.isOn = false
        }
        datePicker.maximumDate = Date()
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedStartDate = formatter.string(from: datePicker.date)
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = components.hour!
        let minute = components.minute!
        let isPrimary = switchOutlet.isOn
        if isPrimary {
            let habitEntities = DatabaseHelper.app.getHabitEntityResults()
            
            for i in 0..<habitEntities.count {
                DatabaseHelper.app.saveHabitEntityAttribute(index: i, attributeName: "isPrimary", data: false)
            }
        }
        let uuid = UUID()
        let reminderFrequencyRawValue = reminderFrequencySegmented.selectedSegmentIndex
        let habitEntity = Habit(name: habitNameTextField.text ?? "", habitCategory: selectedCategory, habitTitle: selectedTitle, reminderFrequency: reminderFrequencyRawValue, startDate: formattedStartDate, startHour: hour, startMinute : minute, isPrimary : isPrimary, notificationId : uuid)
        DatabaseHelper.app.insertHabitEntity(data: habitEntity)
        let frequency = ReminderFrequency(rawValue : reminderFrequencyRawValue)
        
        if frequency != ReminderFrequency.NEVER {
            NotificationHelper.app.scheduleNotification(title: "Habit Reminder", body: habitEntity.name, frequency: frequency ?? ReminderFrequency.DAILY, identifier: uuid.uuidString.lowercased())
        }
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
}
