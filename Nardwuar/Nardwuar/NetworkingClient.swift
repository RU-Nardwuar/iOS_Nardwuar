//
//  NetworkingClient.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/31/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient{
    //https://jsonplaceholder.typicode.com/posts
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
//POST REQUESTS
    func POSTfirstTimeUser(uid:String, name:String, username:String){//_ url: URL, uid:String
        //var request = URLRequest(url: URL(string: "https://nardwuar.herokuapp.com/register")!)
        let urlString = "https://nardwuar.herokuapp.com/register"
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
    func GETaccountData(_ url: URL, completion: @escaping WebServiceResponse){
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
