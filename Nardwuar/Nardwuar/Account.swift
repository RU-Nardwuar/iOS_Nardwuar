//
//  Account.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/13/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//
/*
    GOALS as of 4.12.19
    - get user/<key>
    - put user/<key> with body
    - get artist-info/key
    - get artist-info?query="name"
    - design artist page
    - design home page
    - code home page, artist page, then profile page
    - make settings page under construction
 
 */
import Foundation

let userJSONData = """
[
    {
        "FollowedArtists": [
            {
                "artist_id": "7rCpeQgJIrKKo6gubCkMDK",
                "artist_name": "Young Jeezy & Kanye"
            },
            {
                "artist_id": "20wkVLutqVOYrc0kxFs7rA",
                "artist_name": "Daniel Caesar"
            },
            {
                "artist_id": "7n2wHs1TKAczGzO7Dd2rGr",
                "artist_name": "Shawn Mendes"
            },
            {
                "artist_id": "3fMbdgg4jU18AjLCKBhRSm",
                "artist_name": "Michael Jackson"
            },
            {
                "artist_id": "74ASZWbe4lXaubB36ztrGX",
                "artist_name": "Bob Dylan"
            },
            {
                "artist_id": "66CXWjxzNUsdJxJ2JdwvnR",
                "artist_name": "Ariana Grande"
            },
            {
                "artist_id": "3gMaNLQm7D9MornNILzdSl",
                "artist_name": "Lionel Richie"
            },
            {
                "artist_id": "5IcR3N7QB1j6KBL8eImZ8m",
                "artist_name": "ScHoolboy Q"
            },
            {
                "artist_id": "13ubrt8QOOCPljQ2FL1Kca",
                "artist_name": "A$AP Rocky"
            },
            {
                "artist_id": "7yO4IdJjCEPz7YgZMe25iS",
                "artist_name": "A$AP Mob"
            },
            {
                "artist_id": "30DhU7BDmF4PH0JVhu8ZRg",
                "artist_name": "Sabrina Claudio"
            }
        ],
        "Name": "XAVIER",
        "Username": "XAVIER LA ROSA",
        "_id": "MIsfgTBtvsSRPtxFavScbQZMq6A2"
    }
]
""".data(using: .utf8)!

public class Account{
    typealias User = [UserElement]
    
    struct UserElement: Decodable {
        let followedArtists: [FollowedArtist]
        let name, username, id: String
        
        enum CodingKeys: String, CodingKey {
            case followedArtists = "FollowedArtists"
            case name = "Name"
            case username = "Username"
            case id = "_id"
        }
    }
    
    struct FollowedArtist: Decodable {
        let artistID, artistName: String
        
        enum CodingKeys: String, CodingKey {
            case artistID = "artist_id"
            case artistName = "artist_name"
        }
    }
    func makeStructForAccount(){
//        let jsonData = try? JSONSerialization.data(withJSONObject:json)
//        let user = try? JSONDecoder().decode(User.self, from: jsonData!)
//        print(user!)

        let user = try? JSONDecoder().decode(UserElement.self, from: userJSONData)
        
        print("**** AFTER NETWORKING CLIENT WENT TO GET METHOD BUT BEFORE CHANGING DATA\n\(String(describing: Constants.structUserData.globalIdToken))")
        print(Constants.structUserData.globalName as Any)
        print(Constants.structUserData.globalUsername as Any)
//        print(user!)
        
        print("**** AFTER NETWORKING CLIENT WENT TO GET METHOD")
        Constants.structUserData.globalName = user?.name
        Constants.structUserData.globalIdToken = user?.id
        Constants.structUserData.globalFollowing = user?.followedArtists
        Constants.structUserData.globalUsername = user?.username
        
        print((String(describing: Constants.structUserData.globalIdToken)))
        print(Constants.structUserData.globalName as Any)
        print(Constants.structUserData.globalUsername as Any)
        print(Constants.structUserData.globalFollowing as Any)
        print(Constants.structUserData.globalIdToken as Any)
//        print(user!)

    }
}
