//
//  TrophyViewController.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 15.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class TrophyViewController : UITableViewController {
    
    private var trophyListVM: CustomTrophyListTableViewModel!
    
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var selectedHabit : HabitEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedHabit = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]
        
        setup()
    }
    
    private func setup() {
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.trophyListVM = CustomTrophyListTableViewModel(trophies: TrophyHelper().prepareTrophyObject())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.trophyListVM == nil ? 0 : self.trophyListVM.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trophyListVM.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.trophyListVM.trophies[section].headerName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toShowTrophyVC", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrophyTableViewCell", for: indexPath) as? CustomTrophyTableViewCell else {
            fatalError("ArticleTableViewCell not found")
        }
        
        let trophyVM = self.trophyListVM.trophyAtIndex(indexPath.section, indexPath.row)
        
        cell.descriptionLabel1.text = trophyVM.description1
        cell.descriptionLabel2.text = trophyVM.description2
        cell.image1.image = trophyVM.image1
        cell.image2.image = trophyVM.image2
        cell.backgroundImage1.image = trophyVM.backgroundImage1
        cell.backgroundImage2.image = trophyVM.backgroundImage2
        
        changeCellAlpha(indexPath, cell)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toShowTrophyVC") {
            let vc = segue.destination as! ShowTrophyViewController
            vc.trophyViewController = self
        }
    }
    
    func popoverDismissed() {
    }
    
    private func setAlpha(_ cell: CustomTrophyTableViewCell, alpha1 : Float, alpha2 : Float) {
        cell.descriptionLabel1.alpha = CGFloat(alpha1)
        cell.image1.alpha = CGFloat(alpha1)
        cell.backgroundImage1.alpha = CGFloat(alpha1)
        cell.descriptionLabel2.alpha = CGFloat(alpha2)
        cell.image2.alpha = CGFloat(alpha2)
        cell.backgroundImage2.alpha = CGFloat(alpha2)
    }
    
    fileprivate func changeCellAlpha(_ indexPath: IndexPath, _ cell: CustomTrophyTableViewCell) {
        if indexPath.section > Int(selectedHabit?.trophyIndex ?? 100) || (indexPath.section >= Int(selectedHabit?.trophyIndex ?? 100) &&  indexPath.row >= Int(selectedHabit?.trophySectionIndex ?? 100)) {
            
            if indexPath.section == Int(selectedHabit?.trophyIndex ?? 100) && indexPath.row == Int(selectedHabit?.trophySectionIndex ?? 100) {
                if selectedHabit?.trophyInnerSectionIndex == 0 {
                    setAlpha(cell, alpha1: 1, alpha2: 0.45)
                }
                else {
                    setAlpha(cell, alpha1: 1, alpha2: 1)
                }
            }
            else {
                setAlpha(cell, alpha1: 0.45, alpha2: 0.45)
            }
        }
        else {
            setAlpha(cell, alpha1: 1, alpha2: 1)
        }
    }
}
