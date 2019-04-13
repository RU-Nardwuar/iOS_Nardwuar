//
//  Artist.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/15/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import Foundation


let ArtistJsonData = """
{[
{
   "Pitchfork": {
       "Albums": [
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
       ]
   },
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

public class Artist {
    
    struct Artist: Codable {
        let pitchfork: Pitchfork
        let spotify: Spotify
        
        enum CodingKeys: String, CodingKey {
            case pitchfork = "Pitchfork"
            case spotify = "Spotify"
        }
    }

    struct Pitchfork: Codable {
        let albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "Albums"
        }
    }

    struct Album: Codable {
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

    public func makeJSON(){
    let albumOwnerDecoder = JSONDecoder()
    do{
        let albumOwner = try albumOwnerDecoder.decode(Artist.self, from: ArtistJsonData)
        
        print(albumOwner.spotify.albums)
        print(albumOwner.spotify.artistName)
        print(albumOwner.spotify.genres)
        print(albumOwner.spotify.totalNumberOfSpotifyFollowers)
        
        print(albumOwner.pitchfork.albums as Any)
        
    } catch{
        print("**** Failed to decode JSON data \(error.localizedDescription)")
    }

    }


}














//struct artistData{
//    let userIsFollowing:Bool
//    let stageName:String
//    let mainGenre:String
//    let doesArtistHaveMultipleNames:Bool
//        let alternativeNames:[String]?
//    let doesArtistHaveLegalName:Bool
//        let legalName:String?
//    let dateBorn:String
//    let cityBorn:String
//    let stateBorn:String
//    let proPic:URL
//    let doesArtistHaveAwards:Bool
//        let awards:[String]?
//    let mostRecentSong:String
//    let mostPopularSong:String
//}

