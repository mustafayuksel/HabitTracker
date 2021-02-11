//
//  SettingsViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 13.08.2019.
//  Copyright © 2019 Mustafa Yuksel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var settingsObject = [SettingsObject]()
    var bannerView: GADBannerView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Back", comment: "")
        self.navigationItem.title = NSLocalizedString("Settings", comment: "")
        var section1 = [String]()
        section1.append(NSLocalizedString("Upgrade", comment: ""))
        section1.append(NSLocalizedString("Restore", comment: ""))
        var section2 = [String]()
        section2.append(NSLocalizedString("SendFeedback", comment: ""))
        section2.append(NSLocalizedString("MoreApps", comment: ""))
        settingsObject.append(SettingsObject(settingsList: section1, headerName: NSLocalizedString("Subscription", comment: "")))
        settingsObject.append(SettingsObject(settingsList: section2, headerName: NSLocalizedString("Support", comment: "")))
        
        SKPaymentQueue.default().add(self)
        
        let removeAds = Constants.Defaults.value(forKey: Constants.Keys.RemoveAds)
        
        if removeAds == nil {
            Constants.Defaults.set(false, forKey: Constants.Keys.RemoveAds)
        }
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 100))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-1847727001534987/2460332609"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        AdsHelper().addBannerViewToView(bannerView, view)
    }
    
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
        if indexPath.section == 0 && indexPath.row == 0 {
            print("User click remove ads button")
            if (SKPaymentQueue.canMakePayments()) {
                let productID:NSSet = NSSet(array: [Constants.PRUDUCT_ID as NSString]);
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start();
                print("Fetching Products");
            } else {
                print("can't make purchases");
            }
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            print("User click restore purchase button")
            if (SKPaymentQueue.canMakePayments()) {
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().restoreCompletedTransactions()
            } else {
                // show error
            }
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
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
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    //Do unlocking etc stuff here in case of new purchase
                    Constants.Defaults.set(true, forKey: Constants.Keys.RemoveAds)
                    removeAds(bannerView)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .failed:
                    print("Purchased Failed");
                    let alert = UIAlertController(title: NSLocalizedString("SmthWrong", comment: ""), message: NSLocalizedString("PurchaseFailed", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .restored:
                    print("Already Purchased")
                    //Do unlocking etc stuff here in case of restor
                    Constants.Defaults.set(true, forKey: Constants.Keys.RemoveAds)
                    removeAds(bannerView)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == Constants.PRUDUCT_ID as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                self.buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    fileprivate func removeAds (_ bannerView: GADBannerView) {
        bannerView.removeFromSuperview()
    }
    
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
    }
}
