//
//  Trophy.swift
//  HabitTracker
//
//  Created by Mustafa Yüksel on 16.02.2021.
//  Copyright © 2021 Mustafa Yuksel. All rights reserved.
//

import Foundation
import UIKit

class Trophy {
    public private(set) var description1 : String
    public private(set) var description2 : String
    public private(set) var backgroundImage1 : UIImage
    public private(set) var backgroundImage2 : UIImage
    public private(set) var image1 : UIImage
    public private(set) var image2 : UIImage
    
    init(description1: String, description2: String, image1 : UIImage, image2 : UIImage, backgroundImage1 : UIImage, backgroundImage2 : UIImage) {
        self.description1 = description1
        self.description2 = description2
        self.image1 = image1
        self.image2 = image2
        self.backgroundImage1 = backgroundImage1
        self.backgroundImage2 = backgroundImage2
    }
}
