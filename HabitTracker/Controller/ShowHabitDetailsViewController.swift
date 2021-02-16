//
//  ShowHabitDetailsViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 26.03.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ShowHabitDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    let dateComponents : [Calendar.Component] = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    var selectedHabit : HabitEntity? = nil
    var bannerView: GADBannerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        selectedHabit = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]
        let removeAds = Constants.Defaults.value(forKey: Constants.Keys.RemoveAds)
        
        if removeAds == nil {
            Constants.Defaults.set(false, forKey: Constants.Keys.RemoveAds)
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1847727001534987/9440673927"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        AdsHelper().addBannerViewToView(bannerView, view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateComponents.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        if indexPath.row == 0 {
            let hour =  selectedHabit!.startHour
            let minute =  selectedHabit!.startMinute
            cell.textLabel?.text = DateHelper.app.calculateDays(startDate: selectedHabit?.startDate ?? Date().description, hour: Int(hour), minute: Int(minute), isNotOnlyDays: selectedHabit?.showYears ?? true, showHours:  false,  hasSuffix: true)
        }
        else {
            cell.textLabel?.text = DateHelper.app.calculatePassedByDateComponent(startDate: selectedHabit?.startDate ?? Date().description, dateComponent: dateComponents[indexPath.row - 1])
        }
        cell.selectionStyle = .none
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imgView.image = UIImage(named: "copy-content.png")!
        cell.accessoryView = imgView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDate = selectedHabit?.startDate ?? Date().description
        let dateDetails = DateHelper.selectedDateToFormattedString(startDate: startDate )
        var cellText = ""
        if indexPath.row == 0 {
            let hour =  selectedHabit!.startHour
            let minute =  selectedHabit!.startMinute
            cellText = DateHelper.app.calculateDays(startDate: selectedHabit?.startDate ?? Date().description, hour: Int(hour), minute: Int(minute), isNotOnlyDays: selectedHabit?.showYears ?? true, showHours:  false,  hasSuffix: true)
        }
        else {
            cellText = DateHelper.app.calculatePassedByDateComponent(startDate: startDate, dateComponent: dateComponents[indexPath.row - 1]) ?? ""
        }
        let text = "\(selectedHabit?.name ?? ""),\(dateDetails )\n\(cellText ) !"
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
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
}
