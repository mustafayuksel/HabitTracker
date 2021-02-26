//
//  ShowTrophyViewController.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 21.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class ShowTrophyViewController : UIViewController {
    
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var trophyTitle: UILabel!
    @IBOutlet weak var trophyDescription: UILabel!
    
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedHabit = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]
        
        let preparedTrophies = TrophyHelper().prepareTrophyObject()
        
        let trophyList = preparedTrophies[Int(selectedHabit?.trophyIndex ?? 0)].trophyList
        let trophy = trophyList[Int(selectedHabit?.trophySectionIndex ?? 0)]
        
        let innerSectionIndex = selectedHabit?.trophyInnerSectionIndex
        
        
        if innerSectionIndex == 0 {
            trophyImage.image = trophy.image1
            trophyDescription.text = trophy.description1
        }
        else {
            trophyImage.image = trophy.image2
            trophyDescription.text = trophy.description2
        }
        trophyTitle.text = selectedHabit?.name
    }
    
    @IBAction func dismissPopover(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
