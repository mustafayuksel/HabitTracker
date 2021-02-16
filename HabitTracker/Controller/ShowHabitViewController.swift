//
//  ShowHabitViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ShowHabitViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    let selectedHabitIndex : Int = Constants.Defaults.value(forKey: Constants.Keys.SelectedHabit) as! Int
    let showHabitImages = ["timer.png", "calendar.png", "gold10.png"]
    var bannerView: GADBannerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
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
        
        self.navigationItem.title = DatabaseHelper.app.getHabitEntityResults()[selectedHabitIndex]?.name
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        if !Reachability.isConnectedToNetwork() {
            self.showNetworkErrorPopup()
        }
        else {
            Constants.Defaults.set(selectedHabitIndex, forKey: Constants.Keys.SelectedHabit)
            self.performSegue(withIdentifier: "toHabitEditVC", sender: nil)
        }
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
        else if indexPath.row == 2 {
            cell.title.text = NSLocalizedString("Trophy", comment: "")
            cell.detail.text = DateHelper.app.calculateDays(startDate: selectedHabit?.startDate ?? Date().description, hour: Int(hour), minute: Int(minute), isNotOnlyDays: selectedHabit?.showYears ?? true, showHours: false,  hasSuffix: false)
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            Constants.Defaults.set(selectedHabitIndex, forKey: Constants.Keys.SelectedHabit)
            performSegue(withIdentifier: "toShowDetailsVC", sender: nil)
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "toTrophyVC", sender: nil)
        }
    }
    
    fileprivate func showNetworkErrorPopup() {
        print("Internet Connection is Not Available!")
        let alert = UIAlertController(title: NSLocalizedString("SmthWrong", comment: ""), message: NSLocalizedString("NoInternetConnection", comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            alert.popoverPresentationController!.permittedArrowDirections = []
            alert.popoverPresentationController!.sourceView = self.view
            alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
