//
//  ShowHabitViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class ShowHabitViewController: UIViewController {
    var selectedHabit : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var habitEntityList : [HabitEntity] = []
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var daysCounterLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        habitEntityList = DatabaseUtil.app.getHabitEntityResults() as! [HabitEntity]
        titleLabel.text = habitEntityList[selectedHabit].name
        icon.image = UIImage(named: Constants.habitTitlesImages[Int(habitEntityList[selectedHabit].habitCategory)][Int(habitEntityList[selectedHabit].habitTitle)])
        daysCounterLabel.text = DateHelper.app.calculateDays(habitEntity: habitEntityList[selectedHabit])
        // Do any additional setup after loading the view, typically from a nib.
    }
}
