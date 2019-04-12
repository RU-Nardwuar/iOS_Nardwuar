//
//  Account.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/13/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

/*
Notes
 James' routes:
    1.) post request to register user
    2.) request for user information (artist array)
    3.) request for artist array
    4.) post request to follow an artist
 
 Login > user has array of all artists they follow (name, id)
 
 Hompage > tableview of array of all artists they follow
    i.) user tap on artist they follow > send id token to route > Artist Page
        Artist Page > use all data from json to fill page
    ii.) user tap searchbar and search > hit enter > output array of top 5 artists (name, id) > tap artist
        Artist Page > use all data from json to fill page
 
 //NEW USER
    //google sign in > POST with id, name, username to backend > now in login page > GET with id > retrieve empty follow array > use search bar hit send uses POST with artistName > tap artist from list > GET with artistName and id > lead to artist page with json data
//EXISTING USER
    //google signi in > POST with id, name, username to backend > already exists throws error > GET with id > retrieve artists they follow
*/

//new comment to check branch
import Foundation

let userJSONData = """
    {
    "id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImZmMWRmNWExNWI1Y2Y1ODJiNjFhMjEzODVjMGNmYWVkZmRiNmE3NDgiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiWGF2aWVyIExhIFJvc2EiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1EX0FVYW5WaWdZRS9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BQ0hpM3JlZzN0cGJHbF81T1ppdHBYOWtjZkROT1RpejVBL3M5Ni1jL3Bob3RvLmpwZyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9uYXJkd3Vhci03ZTZmYyIsImF1ZCI6Im5hcmR3dWFyLTdlNmZjIiwiYXV0aF90aW1lIjoxNTU0MDQyMzcyLCJ1c2VyX2lkIjoiVTY1QkljdW80T1pySWIxMGxaQ2tUdjY1Y0Q0MiIsInN1YiI6IlU2NUJJY3VvNE9ackliMTBsWkNrVHY2NWNENDIiLCJpYXQiOjE1NTQwNDIzNzMsImV4cCI6MTU1NDA0NTk3MywiZW1haWwiOiJsYXJvc2EueGF2aWVyQHN0dWRlbnQuY2NtLmVkdSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA3OTQ0MjE4MjQ5NjE3NDc2MTc3Il0sImVtYWlsIjpbImxhcm9zYS54YXZpZXJAc3R1ZGVudC5jY20uZWR1Il19LCJzaWduX2luX3Byb3ZpZGVyIjoiZ29vZ2xlLmNvbSJ9fQ.eWk-_FjZexQ0q_5RruM_PenIXUWpZKX4OtnOkbeiEEwAd5J4eeHD7f_f-Xs0siONA4bUGlD9CZkcklS_QqEEw6VmfwX_iCuthc2F6LPEIPDTSdgeuwPK6e3_fmU31kRhyJeIs2qZPs5L__w3yOXB0tVWpT4XCsRFAXX-w00b9cCKTQHohG9o-4TMtmM_sZLHrZsahwqyH5XKeoTfq3_2nggBVwmPGfAc71FJbm_uy5Ag6XWVR01JMpEGRQAbp1w9qtK0eXbIDWlfqCdQXLtt2lizgND43w1t4U4lotkjDCHYHRgpB99etxvbpPtWKkvEGJ4Iw3Jd2ao06FUHenOXUQ",
        "name":"Xavier",
        "username":"Xavier La Rosa",
        "following" : [
            {
                "Artist name": "Drake",
                "Artist id": "123454362341"
            }
        ]
    }
""".data(using: .utf8)!

struct User: Codable {
    let idToken, name, username: String
    let following: [Following]
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
        case name, username, following
    }
}

struct Following: Codable {
    let artistName, artistID: String
    
    enum CodingKeys: String, CodingKey {
        case artistName = "Artist name"
        case artistID = "Artist id"
    }
}

public class Account{
func addDecodedJSONToConstantsStruct(){
    let user = try? JSONDecoder().decode(User.self, from: userJSONData)
    print(user!.following[0] as Any)
    print(user!.idToken as Any)
    print(user!.name as Any)
    print(user!.username as Any) // make them user? when implementing
    print("**** AFTER NETWORKING CLIENT WENT TO GET METHOD BUT BEFORE CHANGING DATA\(Constants.structUserData.globalIdToken)")
    print(Constants.structUserData.globalName)
    print(Constants.structUserData.globalUsername)
    Constants.structUserData.globalIdToken = user!.idToken
    Constants.structUserData.globalName = user!.name
    Constants.structUserData.globalUsername = user!.username
    //Constants.structUserData.globalFollowing = user!.following
}
}
