import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.habittracker")
        storeURL = storeURL?.appendingPathComponent("HabitTracker.xcdatamodeld")
        return storeURL!
    }
}
