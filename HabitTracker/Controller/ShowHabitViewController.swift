//
//  ShowHabitViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ShowHabitViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate{
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    
    let showHabitImages = ["medal.png", "calendar.png"]
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editButtonAction(_ sender: Any) {
        Constants.Defaults.set(selectedHabitIndex, forKey: Constants.Keys.SelectedHabit)
        self.performSegue(withIdentifier: "toHabitEditVC", sender: nil)
    }
    @IBAction func shareButtonAction(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        let excludeActivities = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.message, UIActivity.ActivityType.mail]
        activityViewController.excludedActivityTypes = excludeActivities
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            activityViewController.popoverPresentationController!.permittedArrowDirections = []
            activityViewController.popoverPresentationController!.sourceView = self.view
            activityViewController.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showHabitImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! CustomShowHabitTableViewCell
        cell.iconImage.image = UIImage(named : showHabitImages[indexPath.row])
        let selectedHabit = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]
        let hour =  selectedHabit!.startHour
        let minute =  selectedHabit!.startMinute
        if indexPath.row == 0 {
            cell.title.text = NSLocalizedString("PassedTime", comment: "")
            cell.detail.text = DateHelper.app.calculateDays(startDate: selectedHabit?.startDate ?? Date().description, hour: Int(hour), minute: Int(minute), isNotOnlyDays: selectedHabit?.showYears ?? true, showHours: false,  hasSuffix: false)
        }
        else if indexPath.row == 1 {
            cell.title.text = NSLocalizedString("Date", comment: "")
            cell.detail.text = DateHelper.selectedDateToFormattedString(startDate: selectedHabit?.startDate ?? Date().description)
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
        performSegue(withIdentifier: "toShowDetailsVC", sender: nil)
    }
}
