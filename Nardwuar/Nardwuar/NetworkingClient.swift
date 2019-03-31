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
