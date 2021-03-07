//
//  ViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 26.07.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import OneSignal
import AppTrackingTransparency

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    private let refreshControl = UIRefreshControl()
    static var isSaveButtonClick:Bool!
    static var showAd = true
    var bannerView: GADBannerView!
    private var habitEntityListVM: CustomMainTableListViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = NSLocalizedString("HabitDayCounter", comment: "")
        
        if(ViewController.showAd) {
            AdsHelper().checkAndAskForAds(uiViewController: self, unitId: "ca-app-pub-1847727001534987/9055444314")
            ViewController.showAd = false
        }
        
        prepareAppearance()
        
        updateHabitsTrophy()
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                Constants.Defaults.set(true, forKey: Constants.Keys.RequestIDFAComplete)
            })
        } else {
            Constants.Defaults.set(true, forKey: Constants.Keys.RequestIDFAComplete)
        }
        
        StoreReviewHelper.checkAndAskForReview()
        let userId = Constants.Defaults.value(forKey: Constants.Keys.UserId) as? String
        if (userId ?? "").isEmpty {
            Timer.scheduledTimer(timeInterval: 10,
                                 target: self,
                                 selector: #selector(self.checkPlayerId),
                                 userInfo: nil,
                                 repeats: true)
        }
        
        buttonLabel.text = NSLocalizedString("NewHabitEvent", comment: "")
        
        setup()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        let removeAds = Constants.Defaults.value(forKey: Constants.Keys.RemoveAds)
        
        if removeAds == nil {
            Constants.Defaults.set(false, forKey: Constants.Keys.RemoveAds)
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1847727001534987/7529969028"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        AdsHelper().addBannerViewToView(bannerView, view)
    }
    
    fileprivate func prepareAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = AppDelegate.UIColorFromHex(rgbValue: 0x0866c2)
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setup() {
        self.habitEntityListVM = CustomMainTableListViewModel(habitEntities: DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity])
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habitEntityListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! CustomMainTableViewCell
        
        let habitEntityVM = self.habitEntityListVM.habitEntityAtIndex(indexPath.row)
        cell.details.text = habitEntityVM.details
        cell.imageView2.image = habitEntityVM.image
        cell.counter.text = habitEntityVM.counterDescription
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal, title: NSLocalizedString("Edit", comment: "")) {  (contextualAction, view, boolValue) in
            if !Reachability.isConnectedToNetwork() {
                self.showNetworkErrorPopup()
            }
            else {
                Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
                self.performSegue(withIdentifier: "toHabitEditVC", sender: nil)
            }
        }
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) {  (contextualAction, view, boolValue) in
            let deleteMenu = UIAlertController(title: nil, message: NSLocalizedString("DeleteItem", comment: ""), preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default){ _ in
                print("Delete")
                if !Reachability.isConnectedToNetwork() {
                    self.showNetworkErrorPopup()
                }
                else {
                    let habitEntityList = DatabaseHelper.app.getHabitEntityResults() as! [HabitEntity]
                    let userId = Constants.Defaults.value(forKey: Constants.Keys.UserId) as? String
                    if !(userId ?? "").isEmpty {
                        let url = Constants.notificationServerUrl + "specialdays/" + userId! + "/" + (habitEntityList[indexPath.row].notificationId?.uuidString ?? "")
                        ApiUtil.app.call(url: url, request: Dictionary<String, String>.init(), httpMethod: "DELETE"){ (response) -> () in
                            print(response)
                            if let isSuccess = response["success"] as? Bool {
                                print("Habit was deleted" + (isSuccess ? "successfully" :"unsuccessfully") )
                                if isSuccess {
                                    DatabaseHelper.app.deleteHabitEntity(index: indexPath.row)
                                    self.setup()
                                }
                            }
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                deleteMenu.popoverPresentationController!.permittedArrowDirections = []
                deleteMenu.popoverPresentationController!.sourceView = self.view
                deleteMenu.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(deleteMenu, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Constants.Defaults.set(indexPath.row, forKey: Constants.Keys.SelectedHabit)
        performSegue(withIdentifier: "toShowHabitVC", sender: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toHabitCategorySelectorVC", sender: nil)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
    
    @objc private func refreshTable(_ sender: Any) {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("HabitDayCounter", comment: "")
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
    
    @objc func checkPlayerId() {
        let userId = Constants.Defaults.value(forKey: Constants.Keys.UserId) as? String
        if (userId ?? "").isEmpty {
            if let deviceState = OneSignal.getDeviceState() {
                let playerId = deviceState.userId
                if playerId != nil {
                    NotificationHelper.init().sendNotificationId(playerId: playerId!)
                }
            }
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
    
    fileprivate func updateHabitsTrophy() {
        let habitEntities = DatabaseHelper.app.getHabitEntityResults()
        
        for i in 0..<habitEntities.count {
            let trophyIndexParts = TrophyHelper().findTrophyIndex(calculatedDays: DateHelper.app.calculatePassedDays(startDate: habitEntities[i]?.startDate ?? Date().description) ?? 0)
            
            let savedIndex = habitEntities[i]?.trophyIndex ?? -1
            let savedSectionIndex = habitEntities[i]?.trophySectionIndex ?? -1
            
            if trophyIndexParts.index != savedIndex || trophyIndexParts.sectionIndex != savedSectionIndex {
                DatabaseHelper.app.updateTrophyData(index: i, trophyParts: trophyIndexParts)
                Constants.Defaults.set(i, forKey: Constants.Keys.SelectedHabit)
                performSegue(withIdentifier: "toShowTrophyVC", sender: nil)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toShowTrophyVC") {
            let vc = segue.destination as! ShowTrophyViewController
            vc.viewController = self
        }
    }
    
    func popoverDismissed() {
        updateHabitsTrophy()
    }
}
