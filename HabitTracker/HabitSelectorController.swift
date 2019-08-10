//
//  HabitCreatorController.swift
//  HabitTracker
//
//  Created by Mustafa on 3.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class HabitSelectorController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    let habitItems = ["Write my own", "Form a Habit"]//["Kendin yaz","Alışkanlık oluştur"]
    let habitImages = ["update.png", "no-smoke.png"]
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hcTransportCell", for: indexPath)
        cell.imageView!.image = UIImage(named: habitImages[indexPath.row]);
        
        cell.textLabel?.text = habitItems[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toCreateHabitDetailsOwnVC", sender: nil)
        }
        else{
            performSegue(withIdentifier: "toCreateHabitDetailsVC", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}
