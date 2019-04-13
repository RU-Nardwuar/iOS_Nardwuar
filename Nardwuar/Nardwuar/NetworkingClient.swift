//
//  NetworkingClient.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/31/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkingClient{
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void

    //POST ACCOUNT
    func POSTfirstTimeUser(uid:String, name:String, username:String){//_ url: URL, uid:String
        let urlString = "https://nardwuar.herokuapp.com/users"
        let json = "{\"id_token\":\"\(uid)\",\"name\":\"\(name)\",\"username\":\"\(username)\"}"
        print("**** json to pass over as string : \(json)")
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        print("**** json to pass over as json : \(jsonData)")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {
            (response) in
            
            print("**** POST REQUEST RESPONSE: \(response)")
        }
    }
    
    //GET ACCOUNT
    func GETaccountData(_ uid: String){
        let urlString = "https://nardwuar.herokuapp.com/users?query=\"\(uid)\""
        print("**** get account data under construction")
        print("**** query: \(uid) \n urlString: \(urlString)")
        Alamofire.request(urlString)
            .responseJSON { response in
                //error
                guard response.result.error == nil else {
                    print("error calling GET")
                    print(response.result.error!)
                    return
                }
                //success
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                print(json)
        }
        //no matter what, we do this at the end of successful method
        let account = Account()
        account.addDecodedJSONToConstantsStruct() //later we want the function to take in a json variable from here
        print("**** AFTER NETWORKING CLIENT WENT TO GET METHOD WENT TO ACCOUNT STRUCT\n\(String(describing: Constants.structUserData.globalIdToken))")
        print(Constants.structUserData.globalName as Any)
        print(Constants.structUserData.globalUsername as Any)
    }
    
    //GET FIRST FIVE
    func GETfirstFiveArtistData(_ query:String){
        let urlString = "https://nardwuar.herokuapp.com/search?query=\"\(query)\""
        print("**** first five get under construction")
        print("**** query: \(query) \n urlString: \(urlString)")
        Alamofire.request(urlString)
            .responseJSON { response in
                //error
                guard response.result.error == nil else {
                    print("error calling GET")
                    print(response.result.error!)
                    return
                }
                //success
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                print(json)
        }
    }

    //GET ARTIST
    func GETartistData(_ url: URL, completion: @escaping WebServiceResponse){
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil)
            } else if let jsonDict = response.result.value as? [String : Any] {
                completion([jsonDict], nil)
            }
        }
    }

}
