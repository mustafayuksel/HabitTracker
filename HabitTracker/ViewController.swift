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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitEntityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        if !habitEntityList.isEmpty {
            cell.textLabel?.text = habitEntityList[indexPath.row].name
            let habitCategory = Int(habitEntityList[indexPath.row].habitCategory)
            let habitTitle = Int(habitEntityList[indexPath.row].habitTitle)
            cell.imageView!.image = UIImage(named: Constants.habitTitlesImages[habitCategory][habitTitle]);
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
