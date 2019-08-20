//
//  HabitCreatorController.swift
//  HabitTracker
//
//  Created by Mustafa on 3.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class HabitCategorySelectorController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.habitCategories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.imageView!.image = UIImage(named: Constants.habitCategoryImages[indexPath.row]);
        cell.textLabel?.text = NSLocalizedString(Constants.habitCategories[indexPath.row], comment: "")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Constants.Defaults.set(0, forKey: Constants.Keys.SelectedCategory)
            performSegue(withIdentifier: "toCreateHabitOwnVC", sender: nil)
        }
        else{
            Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedCategory)
            performSegue(withIdentifier: "toHabitTitleSelectorVC", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("PickCategory", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}
