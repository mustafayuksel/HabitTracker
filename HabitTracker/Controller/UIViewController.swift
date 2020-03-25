//
//  UIViewController.swift
//  HabitTracker
//
//  Created by Mustafa on 23.03.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import UIKit

import UIKit

extension UIViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
