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
            let calculatedDay = DateHelper.app.calculateDays(habitEntity: habitEntityList[indexPath.row])
            cell.counter.text = calculatedDay
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
            self.performSegue(withIdentifier: "toHabitEditVC", sender: nil)
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let deleteMenu = UIAlertController(title: nil, message: "Delete this item", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default){ _ in
                print("Delete")
                DatabaseUtil.app.deleteHabitEntity(index: indexPath.row)
                self.habitEntityList = DatabaseUtil.app.getHabitEntityResults() as! [HabitEntity]
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
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
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
}
