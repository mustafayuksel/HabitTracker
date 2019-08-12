//
//  ViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 26.07.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    var habitEntityList : [HabitEntity] = []
    static var isSaveButtonClick:Bool!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitEntityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! CustomMainTableViewCell
        if !habitEntityList.isEmpty {
            cell.details.text = habitEntityList[indexPath.row].name
            let habitCategory = Int(habitEntityList[indexPath.row].habitCategory)
            let habitTitle = Int(habitEntityList[indexPath.row].habitTitle)
            cell.cellImage.image = UIImage(named: Constants.habitTitlesImages[habitCategory][habitTitle])
            let startDate = habitEntityList[indexPath.row].startDate
            let hour = habitEntityList[indexPath.row].startHour
            let minute = habitEntityList[indexPath.row].startMinute
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let formattedStartDate = dateFormatter.date(from:startDate!)!
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "GMT+0:00")!
            let selectedDate = calendar.date(bySettingHour: Int(hour), minute: Int(minute), second: 0, of: formattedStartDate)!
            let currentDate = Date()
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
            let epochDate = currentDate.timeIntervalSince1970
            // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
            //    local date since 1970.
            //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
            //    calculates correctly.
            let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
            // 4) Finally, create a date using the seconds offset since 1970 for the local date.
            let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
            let component = Set<Calendar.Component>([.day])
            let differenceOfDate = calendar.dateComponents(component, from: selectedDate, to: timeZoneOffsetDate)
            if let dayText: String = String(describing: differenceOfDate.day!) {
                cell.counter.text = dayText + " Gün"
            }
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // 1
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            // 2
            
            //self.present(shareMenu, animated: true, completion: nil)
        })
        // 3
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            // 4
            let deleteMenu = UIAlertController(title: nil, message: "Delete this item", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            
            self.present(deleteMenu, animated: true, completion: nil)
        })
        // 5
        return [deleteAction, editAction]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        if ViewController.isSaveButtonClick == true {
            ViewController.isSaveButtonClick = !ViewController.isSaveButtonClick
            //callSecondFunction()
        }
        buttonLabel.text = NSLocalizedString("NewHabitEvent", comment: "")
        habitEntityList = DatabaseUtil.app.getHabitEntityResults() as! [HabitEntity]
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toHabitCategorySelectorVC", sender: nil)
    }
}
