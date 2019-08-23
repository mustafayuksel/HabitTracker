//
//  HabitEditController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//


import UIKit

class HabitEditViewController : UIViewController {
    
    var selectedHabit : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var habitEntityList : [HabitEntity] = []
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var frequencyLabel: UILabel!
    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var frequencySegment: UISegmentedControl!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var updateButton: UIBarButtonItem!
    
    @IBOutlet var switchOutlet: UISwitch!
    @IBAction func updateAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedStartDate = formatter.string(from: datePicker.date)
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = components.hour!
        let minute = components.minute!
        let isPrimary = switchOutlet.isOn
        
        if isPrimary {
            let habitEntities = DatabaseUtil.app.getHabitEntityResults()
            
            for i in 0..<habitEntities.count {
                DatabaseUtil.app.saveHabitEntityAttribute(index: i, attributeName: "isPrimary", data: false)
            }
        }
        
        let habit = Habit(name: nameTextField.text ?? "", habitCategory: 0, habitTitle: 0, reminderFrequency: frequencySegment.selectedSegmentIndex, startDate: formattedStartDate, startHour: hour, startMinute : minute, isPrimary : isPrimary)
        DatabaseUtil.app.updateData(index: selectedHabit, habit: habit)
        ViewController.isSaveButtonClick = true
        performSegue(withIdentifier: "fromEditToMainVC", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = NSLocalizedString("Date", comment: "")
        timeLabel.text = NSLocalizedString("Time", comment: "")
        switchLabel.text =  NSLocalizedString("SetPrimaryForWidget", comment: "")
        frequencyLabel.text = NSLocalizedString("ReminderFrequency", comment: "")
        updateButton.title = NSLocalizedString("Update", comment: "")
        frequencySegment.setTitle(NSLocalizedString("Daily", comment: ""), forSegmentAt: 0)
        frequencySegment.setTitle(NSLocalizedString("Weekly", comment: ""), forSegmentAt: 1)
        frequencySegment.setTitle(NSLocalizedString("Monthly", comment: ""), forSegmentAt: 2)
        frequencySegment.setTitle(NSLocalizedString("Yearly", comment: ""), forSegmentAt: 3)
        frequencySegment.setTitle(NSLocalizedString("Never", comment: ""), forSegmentAt: 4)
        
        habitEntityList = DatabaseUtil.app.getHabitEntityResults() as! [HabitEntity]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:habitEntityList[selectedHabit].startDate!)
        datePicker.date = date ?? Date()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let time = calendar.date(bySettingHour: Int(habitEntityList[selectedHabit].startHour), minute: Int(habitEntityList[selectedHabit].startMinute), second: 0, of: Date())!
        timePicker.date = time
        
        nameTextField.text = habitEntityList[selectedHabit].name
        
        frequencySegment.selectedSegmentIndex = Int(habitEntityList[selectedHabit].reminderFrequency)
        
        switchOutlet.isOn = habitEntityList[selectedHabit].isPrimary
    }
}
