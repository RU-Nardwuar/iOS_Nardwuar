//
//  Account.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/13/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation

struct AccountDetails {
    //variables you can access per day
    let summary:String
    let icon:String
    //catch errors
    enum errorType:Error {
        case dataPieceIsMissing(String)
        case invalid(String, Any)
    }
    
    //grabbing specific json data
    init(json:[String:Any]) throws {
        print("**** inside json constructor")
        guard let summary = json["summary"] as? String else {throw errorType.dataPieceIsMissing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw errorType.dataPieceIsMissing("icon is missing")}
        
        self.summary = summary
        self.icon = icon
    }
    //standard path for darksky api
    static let basePath = "https://api.darksky.net/forecast/4236058e5c8982e67c6c8cf72e75cc6e/"
    
    //makes unique path refer to users input
    static func getAccountDetails(email:String, completion: @escaping ([AccountDetails]?) -> ()){
        print("**** inside getAccountDetails function")
        var url = basePath
        url = basePath // + something else
        print("**** specific url: \(url)")
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var accountArray:[AccountDetails] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] { // first directory
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] { //second directory
                                for dataPoint in dailyData {
//                                  //adding object to accountArray
//                                    if let accountObject = try? AccountDetails(json: dataPoint) {
//                                        accountArray.append(accountObject)
//                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(accountArray)
                print("**** Account Array Completed: \(accountArray)")
            }
        }
        task.resume()
    }
    
}
