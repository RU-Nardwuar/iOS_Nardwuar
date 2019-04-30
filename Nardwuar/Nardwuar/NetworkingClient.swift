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
    
    //POST FOLLOW ARTIST
    func POSTfollowNewArtist(token:String, artistName:String, artistId:String){//_ url: URL, uid:String
        let urlString = "https://nardwuar.herokuapp.com/follow?id_token=\(token)"
        let json = "{\"artist_name\":\"\(artistName)\",\"artist_id\":\"\(artistId)\"}"
        print("**** POST FOLLOW ARTIST: json to pass over as string ... \(json) \n with link ... \(urlString)")
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
//    }
//    //POST UNFOLLOW ARTIST
//    func POSTunfollowNewArtist(token:String, artistName:String, artistId:String){//_ url: URL, uid:String
//        let urlString = "https://nardwuar.herokuapp.com/follow?id_token=\(token)"
//        let json = "{\"artist_name\":\"\(artistName)\",\"artist_id\":\"\(artistId)\"}"
//        print("**** POST FOLLOW ARTIST: json to pass over as string ... \(json) \n with link ... \(urlString)")
//        let url = URL(string: urlString)!
//        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
//        print("**** json to pass over as json : \(jsonData)")
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        
//        Alamofire.request(request).responseJSON {
//            (response) in
//            
//            print("**** POST REQUEST RESPONSE: \(response)")
//        }
//    }
}
