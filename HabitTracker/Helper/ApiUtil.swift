//
//  ApiUtil.swift
//  HabitTracker
//
//  Created by Mustafa on 26.03.2020.
//  Copyright © 2020 Mustafa Yuksel. All rights reserved.
//

import Foundation

class ApiUtil {
    static var app: ApiUtil = {
        return ApiUtil()
    }()
    
    func call(url : String, request : Dictionary<String, String>, httpMethod : String, completion: @escaping (_ response: Dictionary<String, AnyObject>)->()) {
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = httpMethod
        if !request.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request, options: [])
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data ?? Data.init()) as? Dictionary<String, AnyObject>
                completion(json ?? Dictionary<String, AnyObject>())
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func sendHabitDetails(habit : Habit, userId : String, httpMethod : String){
        let request = ["userId" : userId, "title": habit.name, "startDate" : habit.startDate, "reminderFrequency" : String(habit.reminderFrequency), "notificationId" : habit.notificationId.uuidString]
        let url = Constants.notificationServerUrl + "specialdays/"
        ApiUtil.app.call(url: url, request: request , httpMethod: httpMethod){ (response) -> () in
            if let isSuccess = response["success"] as? Bool {
                print("Habit details have been sent" + (isSuccess ? "successfully" :"unsuccessfully") )
            }
        }
    }
}
