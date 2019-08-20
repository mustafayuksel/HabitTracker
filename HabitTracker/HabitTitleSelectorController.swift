//
//  HabitTitleSelectorController.swift
//  HabitTracker
//
//  Created by Mustafa on 10.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class HabitTitleSelectorController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var selectedCategory : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedCategory) as! Int
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.habitTitles[selectedCategory].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        cell.imageView!.image = UIImage(named:  Constants.habitTitlesImages[selectedCategory][indexPath.row]);
        cell.textLabel?.text =  NSLocalizedString(Constants.habitTitles[selectedCategory][indexPath.row], comment: "")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedTitle)
        performSegue(withIdentifier: "toCreateHabitVC", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = NSLocalizedString(Constants.habitCategories[selectedCategory], comment: "")
        tableView.tableFooterView = UIView()
    }
}
