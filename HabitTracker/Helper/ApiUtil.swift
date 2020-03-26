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
}
