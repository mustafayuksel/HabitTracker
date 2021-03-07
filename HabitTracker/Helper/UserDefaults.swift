//
//  UserDefaults.swift
//  LovelyDays
//
//  Created by Mustafa Yüksel on 20.09.2020.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import Foundation
extension UserDefaults {

    private static let migrator = UserStandardsMigrator(
        from: .standard,
        to: UserDefaults(suiteName: "group.steps.plus") ?? .standard)


    @objc static let appGroup: UserDefaults = {
        migrator.migrate()
        return migrator.defaults()
    }()
}
