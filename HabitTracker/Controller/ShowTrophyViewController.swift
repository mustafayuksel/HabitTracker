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
    
    var viewController : ViewController? = nil
    var trophyViewController : TrophyViewController? = nil
    
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var trophyTitle: UILabel!
    @IBOutlet weak var trophyDescription: UILabel!
    
    
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedHabit = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]
        
        let preparedTrophies = TrophyHelper().prepareTrophyObject()
        
        var trophyIndex = 0
        if Int(selectedHabit?.trophyIndex ?? 0) > -1 {
            trophyIndex = Int(selectedHabit?.trophyIndex ?? 0)
        }
        
        let trophyList = preparedTrophies[trophyIndex].trophyList
        
        var trophySectionIndex = 0
        if Int(selectedHabit?.trophySectionIndex ?? 0) > -1 {
            trophySectionIndex = Int(selectedHabit?.trophySectionIndex ?? 0)
        }
        
        let trophy = trophyList[trophySectionIndex]
        
        let innerSectionIndex = selectedHabit?.trophyInnerSectionIndex ?? 0 > -1 ? selectedHabit?.trophyInnerSectionIndex ?? 0 : 0
        
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
        
        if viewController != nil {
            viewController?.popoverDismissed()
        }
        else if trophyViewController != nil {
            trophyViewController?.popoverDismissed()
        }
    }
}
