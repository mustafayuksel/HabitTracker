//
//  HabitEditController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//


import UIKit
import GoogleMobileAds

class HabitEditViewController : UIViewController, GADBannerViewDelegate {
    
    var selectedHabit : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var habitEntityList : [HabitEntity] = []
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var bannerView: GADBannerView!
    
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var timeOutlet: UITextField!
    @IBOutlet weak var reminderFrequencyLabel: UILabel!
    @IBOutlet weak var showWidgetLabel: UILabel!
    @IBOutlet weak var showYearLabel: UILabel!
    @IBOutlet weak var showHourLabel: UILabel!
    @IBOutlet weak var reminderFrequencyOutlet: UISegmentedControl!
    @IBOutlet weak var widgetSwitchOutlet: UISwitch!
    @IBOutlet weak var showYearSwitchOutlet: UISwitch!
    @IBOutlet weak var showHourSwitchOutlet: UISwitch!
    @IBOutlet var updateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdsHelper().checkAndAskForAds(uiViewController: self, unitId: "ca-app-pub-1847727001534987/4875885525")
        self.setupToHideKeyboardOnTapOnView()

        let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 100))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-1847727001534987/8815130538"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        AdsHelper().addBannerViewToView(bannerView, view)
        
        dateOutlet.placeholder = "  " + NSLocalizedString("Date", comment: "")
        timeOutlet.placeholder = "  " + NSLocalizedString("Time", comment: "")
        showYearLabel.text = NSLocalizedString("ShowYears", comment: "")
        showHourLabel.text = NSLocalizedString("ShowHours", comment: "")
        showWidgetLabel.text =  NSLocalizedString("SetPrimaryForWidget", comment: "")
        reminderFrequencyLabel.text = NSLocalizedString("ReminderFrequency", comment: "")
        updateButton.title = NSLocalizedString("Update", comment: "")
        reminderFrequencyOutlet.setTitle(NSLocalizedString("Daily", comment: ""), forSegmentAt: 0)
        reminderFrequencyOutlet.setTitle(NSLocalizedString("Weekly", comment: ""), forSegmentAt: 1)
        reminderFrequencyOutlet.setTitle(NSLocalizedString("Monthly", comment: ""), forSegmentAt: 2)
        reminderFrequencyOutlet.setTitle(NSLocalizedString("Yearly", comment: ""), forSegmentAt: 3)
        reminderFrequencyOutlet.setTitle(NSLocalizedString("Never", comment: ""), forSegmentAt: 4)
        
        habitEntityList = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
        let startDate = habitEntityList[selectedHabit].startDate ?? ""
        dateOutlet.text = "  " + startDate
        dateOutlet.addTarget(self, action: #selector(showDatePicker), for: .editingDidBegin)
        dateOutlet.inputView = UIView()
        
        let startHour = habitEntityList[selectedHabit].startHour
        let startMinute = habitEntityList[selectedHabit].startMinute
        if startHour > 0 || startMinute > 0 {
            timeOutlet.text = "  " + String(startHour) + " : " + String(startMinute)
        }
        timeOutlet.addTarget(self, action: #selector(showTimePicker), for: .editingDidBegin)
        timeOutlet.inputView = UIView()
        
        titleOutlet.text = "  " + (habitEntityList[selectedHabit].name ?? "")
        
        reminderFrequencyOutlet.selectedSegmentIndex = Int(habitEntityList[selectedHabit].reminderFrequency)
        
        widgetSwitchOutlet.isOn = habitEntityList[selectedHabit].isPrimary
        showYearSwitchOutlet.isOn = habitEntityList[selectedHabit].showYears
        showHourSwitchOutlet.isOn = habitEntityList[selectedHabit].showHours
    }
    
    fileprivate func showAlertForMissingField(errorMessage : String) {
        let alert = UIAlertController(title: NSLocalizedString("MissingField", comment: ""), message: NSLocalizedString(errorMessage, comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateAction(_ sender: Any) {
        var title = titleOutlet.text
        if !(title ?? "").isEmpty {
            title = title!.trimmingCharacters(in: .whitespaces)
            if (title ?? "").isEmpty {
                showAlertForMissingField(errorMessage : "TitleShouldBeEntered")
                return
            }
        }
        else {
            showAlertForMissingField(errorMessage : "TitleShouldBeEntered")
            return
        }
        let date = dateOutlet.text!.trimmingCharacters(in: .whitespaces)
        
        if date.isEmpty {
            showAlertForMissingField(errorMessage : "DateShouldBeEntered")
            return
        }
        let isPrimary = widgetSwitchOutlet.isOn
        
        if isPrimary {
            let habitEntities = DatabaseHelper.app.getHabitEntityResults()
            
            for i in 0..<habitEntities.count {
                DatabaseHelper.app.saveHabitEntityAttribute(index: i, attributeName: "isPrimary", data: false)
            }
        }
        let showYears = showYearSwitchOutlet.isOn
        let showHours = showHourSwitchOutlet.isOn
        
        var hour = 0
        var minute = 0
        let timeArray = timeOutlet.text!.trimmingCharacters(in: .whitespaces).split(separator: ":")
        if !timeArray.isEmpty {
            hour = Int(timeArray[0].trimmingCharacters(in: .whitespaces))!
            minute = Int(timeArray[1].trimmingCharacters(in: .whitespaces))!
        }
        
        let reminderFrequencyRawValue = reminderFrequencyOutlet.selectedSegmentIndex
        let trophyIndexParts = TrophyHelper().findTrophyIndex(calculatedDays: DateHelper.app.calculatePassedDays(startDate: date) ?? 0)
        let habit = Habit(name: title!, habitCategory: 0, habitTitle: 0, reminderFrequency: reminderFrequencyRawValue, startDate: date, startHour: hour, startMinute : minute, isPrimary : isPrimary, notificationId : habitEntityList[selectedHabit].notificationId ?? UUID(), showYears : showYears, showHours : showHours, trophyIndex : trophyIndexParts.0, trophySectionIndex : trophyIndexParts.1, trophyInnerSectionIndex : trophyIndexParts.2)
        DatabaseHelper.app.updateData(index: selectedHabit, habit: habit)
        let userId = Constants.Defaults.value(forKey: Constants.Keys.UserId) as? String
        if !(userId ?? "").isEmpty {
            ApiUtil.app.sendHabitDetails(habit: habit, userId: userId!, httpMethod: "PUT")
        }
        performSegue(withIdentifier: "fromEditToMainVC", sender: nil)
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let width = self.view.frame.size.width
        let toastLabel = UILabel(frame: CGRect(x: width - 300 - ((width - 300)/2), y: self.view.frame.size.height/2, width: 300, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = NSLocalizedString("WidgetInfoMessage", comment: "")
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.09, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    @objc func showDatePicker(){
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:dateOutlet.text?.trimmingCharacters(in: .whitespaces) ?? Date().description)
        datePicker.date = date ?? Date()
        datePicker.maximumDate = Date()
        dateOutlet.inputAccessoryView = toolbar
        dateOutlet.inputView = datePicker
    }
    
    @objc func showTimePicker(){
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelTimePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        var hour = 0
        var minute = 0
        let timeArray = timeOutlet.text?.trimmingCharacters(in: .whitespaces).split(separator: ":")
        if !(timeArray?.isEmpty ?? true) {
            hour = Int(timeArray?[0].trimmingCharacters(in: .whitespaces) ?? "0") ?? 0
            minute = Int(timeArray?[1].trimmingCharacters(in: .whitespaces) ?? "0") ?? 0
        }
        if hour > 0 || minute > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            let parsedDate = String(hour) + ":" + String(minute)
            let date = dateFormatter.date(from: parsedDate)
            timePicker.date = date ?? Date()
        }
        

        
        timeOutlet.inputAccessoryView = toolbar
        timeOutlet.inputView = timePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOutlet.text = "  " + formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func doneTimePicker(){
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = components.hour!
        let minute = components.minute!
        timeOutlet.text = "  " + String(hour) + " : " + String(minute)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker(){
        self.view.endEditing(true)
    }
}
