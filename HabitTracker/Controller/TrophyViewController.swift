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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return cell
    }
}
