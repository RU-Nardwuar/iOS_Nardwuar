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
    //https://jsonplaceholder.typicode.com/posts
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
//POST REQUESTS
    func POSTfirstTimeUser(uid:String, name:String, username:String){//_ url: URL, uid:String
        //var request = URLRequest(url: URL(string: "https://nardwuar.herokuapp.com/register")!)
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
    
//GET REQUESTS
    //get request is working for accountData
    func GETaccountData(_ uid: String){ //4.12.19 commented out ", completion: @escaping WebServiceResponse" in func
        
        let urlString = "https://nardwuar.herokuapp.com/users"
        let url = URL(string: urlString)!
        
//METHOD 1
//        let json = "{\"id_token\":\"\(uid)\"}"
//        print("**** json to pass over as string : \(json)")
//        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
//        print("**** json to pass over as json : \(jsonData)")
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData

//METHOD 2 ... second best
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        let params: Parameters = [
            "location": [12.12, 12.12]
        ]
        do{
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            print("**** METHOD 2 SUCCESS:\n \(urlRequest)\n**** END")
        } catch{
            print("**** was not able to retrieve get uesr METHOD 2: \(error.localizedDescription)")
        }
        
//METHOD 3 ... best
        Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                print("**** METHOD 3 SUCCESS: \(JSON)")
                //parse your response here
            case .failure(let error):
                print("**** was not able to retrieve get user METHOD 3\(error)")
            }
        }
//METHOD 4
//        Alamofire.request(urlString).validate().responseJSON { response in
//            if let error = response.error {
//                completion(nil, error)
//            } else if let jsonArray = response.result.value as? [[String: Any]] {
//                completion(jsonArray, nil)
//            } else if let jsonDict = response.result.value as? [String : Any] {
//                completion([jsonDict], nil)
//            }
//        }
        //no matter what we do this at the end of successful method
        let account = Account()
        account.addDecodedJSONToConstantsStruct() //later we want the function to take in a json variable from here
        print("**** AFTER NETWORKING CLIENT WENT TO GET METHOD WENT TO ACCOUNT STRUCT\n\(String(describing: Constants.structUserData.globalIdToken))")
        print(Constants.structUserData.globalName as Any)
        print(Constants.structUserData.globalUsername as Any)
    }
    
    //get request is working for artistData
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
    
    //get request is working for first five artists
    func GETfirstFiveArtistData(_ url: URL, completion: @escaping WebServiceResponse){
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
