import UIKit
import Foundation



//////////////////////////////////// ARTIST JSON DATA ////////////////////////////////////////////////////////
let ArtistJsonData = """
{[
{
   "Pitchfork": [
           {
               "Album name": "KIDS SEE GHOSTS",
               "Album description": "The psychic bond between Kanye West and Kid Cudi yields a spacious and melancholy album about brokenness—thoughts are fragmented, relationships are ended, and societal ties are cut.\n",
               "Album score": 7.6,
               "Album year": "2018",
               "Best New Music": false,
               "Label": "G.O.O.D. Music / Def Jam"
           },
           {
               "Album name": "The Life Of Pablo",
               "Album description": "Finally, after a protracted and often chaotic roll-out, the new Kanye West album is here. The Life of Pablo is the first Kanye West album that's just an album: No major statements, no reinventions, no zeitgeist wheelie-popping. But a madcap sense of humor animates all his best work, and the new record has a freewheeling energy that is infectious and unique to his discography.\n",
               "Album score": 9,
               "Album year": "2016",
               "Best New Music": true,
               "Label": "G.O.O.D. Music / Def Jam"
           },
           {
               "Album name":"Ye",
               "Album description": "Kanye West’s stint in Wyoming created an album born from chaos for chaos’ sake. Though it can be somewhat fascinating, it is undoubtedly a low point in his career.\n",
               "Album score": 7.1,
               "Album year": "2018",
               "Best New Music": false,
               "Label": "G.O.O.D. Music / Def Jam"
           }
   ],
   "Spotify": {
       "Albums": [
       "KIDS SEE GHOSTS",
       "ye",
       "The Life Of Pablo",
       "Yeezus",
       "Kanye West Presents Good Music Cruel Summer",
       "My Beautiful Dark Twisted Fantasy",
       "808s & Heartbreak",
       "Graduation (French Limited Version)",
       "Graduation",
       "Graduation (Exclusive Edition)",
       "Graduation (Alternative Business Partners)",
       "Late Orchestration",
       "Late Registration"
       ],
       "Artist Name": "Kanye West",
       "Genres": [
       "chicago rap",
       "pop rap",
       "rap"
       ],
       "Total Number of Spotify Followers": 9533117
   }
}
]}
""".data(using: .utf8)!

import Foundation

struct Artist: Codable {
    let pitchfork: [Pitchfork]
    let spotify: Spotify
    
    enum CodingKeys: String, CodingKey {
        case pitchfork = "Pitchfork"
        case spotify = "Spotify"
    }
}

struct Pitchfork: Codable {
    let albumName, albumDescription: String
    let albumScore: Double
    let albumYear: String
    let bestNewMusic: Bool
    let label: String
    
    enum CodingKeys: String, CodingKey {
        case albumName = "Album name"
        case albumDescription = "Album description"
        case albumScore = "Album score"
        case albumYear = "Album year"
        case bestNewMusic = "Best New Music"
        case label = "Label"
    }
}

struct Spotify: Codable {
    let albums: [String]
    let artistName: String
    let genres: [String]
    let totalNumberOfSpotifyFollowers: Int
    
    enum CodingKeys: String, CodingKey {
        case albums = "Albums"
        case artistName = "Artist Name"
        case genres = "Genres"
        case totalNumberOfSpotifyFollowers = "Total Number of Spotify Followers"
    }
}
let artist = try? JSONDecoder().decode(Artist.self, from: ArtistJsonData)
print(artist as Any)


//////////////////////////////////// USER JSON DATA ////////////////////////////////////////////////////////
let userJSONData = """
{[
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
]}
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
let user = try? JSONDecoder().decode(User.self, from: userJSONData)
print(user as Any)
