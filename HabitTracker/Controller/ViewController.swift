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
    private let refreshControl = UIRefreshControl()
    
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
            if habitCategory != 0 {
                cell.imageView?.image = UIImage(named: Constants.habitTitlesImages[habitCategory][habitTitle])
            }
            else {
                cell.imageView?.image = UIImage(named: "punctuality.png")
            }
            let startDate =  habitEntityList[indexPath.row].startDate
            let hour =  habitEntityList[indexPath.row].startHour
            let minute =  habitEntityList[indexPath.row].startMinute
            cell.counter.text = DateHelper.app.calculateDays(startDate: startDate!, hour: Int(hour), minute: Int(minute))
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let editAction = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "") , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
            self.performSegue(withIdentifier: "toHabitEditVC", sender: nil)
        })
        let deleteAction = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "") , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let deleteMenu = UIAlertController(title: nil, message: NSLocalizedString("DeleteItem", comment: ""), preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default){ _ in
                print("Delete")
                self.habitEntityList = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
                var identifiers : [String] = []
            identifiers.append((self.habitEntityList[indexPath.row].notificationId?.uuidString.lowercased())!)
                NotificationHelper.app.unscheduleNotification(identifiers: identifiers)
                
                DatabaseHelper.app.deleteHabitEntity(index: indexPath.row)
                
                self.habitEntityList = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                deleteMenu.popoverPresentationController!.permittedArrowDirections = []
                deleteMenu.popoverPresentationController!.sourceView = self.view
                deleteMenu.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(deleteMenu, animated: true, completion: nil)
        })
        return [deleteAction, editAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
        performSegue(withIdentifier: "toShowHabitVC", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("HabitDayCounter", comment: "")
        if ViewController.isSaveButtonClick == true {
            ViewController.isSaveButtonClick = !ViewController.isSaveButtonClick
            //callSecondFunction()
        }
        buttonLabel.text = NSLocalizedString("NewHabitEvent", comment: "")
        habitEntityList = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toHabitCategorySelectorVC", sender: nil)
    }
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
    @objc private func refreshTable(_ sender: Any) {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
