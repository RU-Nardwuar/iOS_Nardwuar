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
        let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(uid)"
        print("**** get account data under construction")
        print("**** query: \(uid) \n urlString: \(urlString)")
        Alamofire.request(urlString,
                          parameters: nil,
                          headers: nil)
            .responseJSON { response in
                // 2
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching: \(String(describing: response.result.error))")
                        return
                        
                }
                //let json = try? JSONSerialization.jsonObject(with: data, options: [value])
                print("**** GET USER SUCCESS \(value)")
                //4.22.19 current error where json is acting weird hard code json for now
                let account = Account()
                account.makeStructForAccount()
        }
    }
    
    //GET FIRST FIVE
    func GETfirstFiveArtistData(_ query:String){
        let urlString = "https://nardwuar.herokuapp.com/search?query=\(query)"
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
                    let artist = Artist()
                    artist.makeStructForArtistQuery()
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                print(json)
                
                let artist = Artist()
                artist.makeStructForArtistQuery()
        }
    }

    //GET ARTIST
    func GETartistData(artistID:String){
        let urlString = "https://nardwuar.herokuapp.com/artist-info/\(artistID)"
        let artist = Artist()
        artist.makeStructForArtist()
        print("**** get account data under construction")
        print("**** query: \(artistID) \n urlString: \(urlString)")
        Alamofire.request(urlString,
                          parameters: nil,
                          headers: nil)
            .responseJSON { response in
                // 2
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching: \(String(describing: response.result.error))")
                        return
                        
                }
                //let json = try? JSONSerialization.jsonObject(with: data, options: [value])
                print("**** GET ARTIST SUCCESS \(value)")
                //4.22.19 current error where json is acting weird hard code json for now
                let artist = Artist()
                artist.makeStructForArtist()
        }
        
    }
}
