//
//  Account.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/13/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation

struct AccountDetails {
    let firstTimeRegistered:Bool
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
        self.firstTimeRegistered = true
        self.summary = summary
        self.icon = icon
    }
    //standard path for darksky api
    static let basePath = "https://nardwuar.herokuapp.com"
    
    //makes unique path refer to users input
    static func registerFirstTimeUser(token:String, completion: @escaping ([AccountDetails]?) -> ()){
        print("*** in register function! with token: \(token)")
        let url = URL(string: "https://nardwuar.herokuapp.com")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        
        let postString = "/\(token)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("***** error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("**** statusCode should be 200, but is \(httpStatus.statusCode)")
                print("**** response = \(response)")
                
                print("Request has not submitted successfully.\nPlease try after some time")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("**** responseString = \(responseString)")
            
            print("Request has submitted successfully.\nPlease wait for a while")
            DispatchQueue.main.async {
                
                
                
                print("**** inside dispatch queue where the code will be")
                
                
            }
            
        }
        task.resume()
    }
    
    static func getAccountDetails(token:String, completion: @escaping ([AccountDetails]?) -> ()){
        print("**** inside getAccountDetails function")
        var url = basePath
        url = basePath
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
