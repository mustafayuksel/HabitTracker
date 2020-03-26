//
//  CustomShowHabitDetails.swift
//  HabitTracker
//
//  Created by Mustafa on 26.03.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import UIKit

class CustomShowHabitDetailsTableViewCell : UITableViewCell {
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 8
            frame.size.width -= 2 * 8
            frame.size.height -= 10
            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
    }
}
