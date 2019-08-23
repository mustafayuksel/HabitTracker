//
//  SettingsViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsObject[section].settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = settingsObject[indexPath.section].settingsList[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsObject.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsObject[section].headerName
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let email = Constants.MAIL_ADDRESS
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            let urlStr = "itms-apps://apps.apple.com/us/app/loving-days-love-counter/id1467362455"
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(URL(string: urlStr)!)
            }
        }
    }
    
    var settingsObject = [SettingsObject]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Back", comment: "")
        self.title = NSLocalizedString("Settings", comment: "")
        var section1 = [String]()
        section1.append(NSLocalizedString("Upgrade", comment: ""))
        section1.append(NSLocalizedString("Restore", comment: ""))
        var section2 = [String]()
        section2.append(NSLocalizedString("SendFeedback", comment: ""))
        section2.append(NSLocalizedString("MoreApps", comment: ""))
        settingsObject.append(SettingsObject(settingsList: section1, headerName: NSLocalizedString("Subscription", comment: "")))
        settingsObject.append(SettingsObject(settingsList: section2, headerName: NSLocalizedString("Support", comment: "")))
    }
}
