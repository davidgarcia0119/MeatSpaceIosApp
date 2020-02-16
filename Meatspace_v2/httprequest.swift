//
//  httprequest.swift
//  meatspaceProject
//
//  Created by MAC on 2/14/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
class httprequest{
    static func send(url:String) -> String {
        let url2 = URL(string: url)
        guard let requestUrl = url2 else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        var resp = ""
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                resp = dataString
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        return resp
    }
}
