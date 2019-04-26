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
{
    "Pitchfork": [
        {
            "Album description": "The psychic bond between Kanye West and Kid Cudi yields a spacious and melancholy album about brokenness—thoughts are fragmented, relationships are ended, and societal ties are cut",
            "Album name": "KIDS SEE GHOSTS",
            "Album photo 640x640": "https://i.scdn.co/image/64cc5671890ba19c6c42a533eed08da56d29bdca",
            "Album score": 7.6,
            "Album year": "2018",
            "Best New Music": false,
            "Label": "G.O.O.D. Music / Def Jam"
        },
        {
            "Album description": "Kanye West’s stint in Wyoming created an album born from chaos for chaos’ sake. Though it can be somewhat fascinating, it is undoubtedly a low point in his career",
            "Album name": "ye",
            "Album photo 640x640": "https://i.scdn.co/image/05cf2f8b56e595bcbf50fccb894f5fb6c2427750",
            "Album score": 7.1,
            "Album year": "2018",
            "Best New Music": false,
            "Label": "G.O.O.D. Music / Def Jam"
        },
        {
            "Album description": "Finally, after a protracted and often chaotic roll-out, the new Kanye West album is here. The Life of Pablo is the first Kanye West album that's just an album: No major statements, no reinventions, no zeitgeist wheelie-popping. But a madcap sense of humor animates all his best work, and the new record has a freewheeling energy that is infectious and unique to his discography",
            "Album name": "The Life Of Pablo",
            "Album photo 640x640": "https://i.scdn.co/image/443372cd2c6d4245833fb46ac1c5dabca00c78a9",
            "Album score": 9,
            "Album year": "2016",
            "Best New Music": true,
            "Label": "Def Jam / G.O.O.D. Music"
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
        "Artist Photo 600x600": "https://i.scdn.co/image/a12d8543e28d71d9f1e7f5f363c1a6c73316f9e6",
        "Genres": [
            "chicago rap",
            "pop rap",
            "rap"
        ],
        "Total Number of Spotify Followers": 9580796
    }
}
""".data(using: .utf8)!

public class Artist {
    
    struct ArtistInfo: Decodable {
        let pitchfork: [Pitchfork]
        let spotify: Spotify
        
        enum CodingKeys: String, CodingKey {
            case pitchfork = "Pitchfork"
            case spotify = "Spotify"
        }
    }
    
    struct Pitchfork: Decodable {
        let albumDescription, albumName: String
        let albumPhoto640X640: String
        let albumScore: Double
        let albumYear: String
        let bestNewMusic: Bool
        let label: String
        
        enum CodingKeys: String, CodingKey {
            case albumDescription = "Album description"
            case albumName = "Album name"
            case albumPhoto640X640 = "Album photo 640x640"
            case albumScore = "Album score"
            case albumYear = "Album year"
            case bestNewMusic = "Best New Music"
            case label = "Label"
        }
    }
    
    struct Spotify: Decodable {
        let albums: [String]
        let artistName: String
        let artistPhoto600X600: String
        let genres: [String]
        let totalNumberOfSpotifyFollowers: Int
        
        enum CodingKeys: String, CodingKey {
            case albums = "Albums"
            case artistName = "Artist Name"
            case artistPhoto600X600 = "Artist Photo 600x600"
            case genres = "Genres"
            case totalNumberOfSpotifyFollowers = "Total Number of Spotify Followers"
        }
    }

    public func makeStructForArtist(){
    let albumOwnerDecoder = JSONDecoder()
    do{
        let albumOwner = try albumOwnerDecoder.decode(ArtistInfo.self, from: ArtistJsonData)
        
        print(albumOwner.spotify.albums) //ARRAY
        print(albumOwner.spotify.artistName) //STRING
        print(albumOwner.spotify.genres) //[STRING]
        print(albumOwner.spotify.totalNumberOfSpotifyFollowers) //INT
        
        print(albumOwner.pitchfork as Any)
        
        Constants.structArtistData.artistPhoto = albumOwner.spotify.artistPhoto600X600
        Constants.structArtistData.artistName = albumOwner.spotify.artistName
        Constants.structArtistData.artistFollowers = albumOwner.spotify.totalNumberOfSpotifyFollowers
        Constants.structArtistData.artistGenres = albumOwner.spotify.genres
        Constants.structArtistData.artistTopAlbums = albumOwner.pitchfork
        Constants.structArtistData.artistAlbums = albumOwner.spotify.albums
        //Constants.structArtistData.artistTopAlbums = albumOwner.pitchfork[0].
    } catch{
        print("**** Failed to decode JSON data \(error.localizedDescription)")
    }

    }

    

    
    
    
    //below is for artist search query
    
    
    
    let artistQueryJSON = """
[
    {
        "Name": "Kanye West",
        "id": "5K4W6rqBFWDnAN6FQUkS6x"
    },
    {
        "Name": "Young Jeezy & Kanye",
        "id": "7rCpeQgJIrKKo6gubCkMDK"
    },
    {
        "Name": "Kanye West for KanMan Productions, Inc. and Krazy Kat Catalogue, Inc.",
        "id": "5xMcX1WiPEq5BMw0Xz42Z4"
    },
    {
        "Name": "Kanye Omari West",
        "id": "2BYfXvfV9YJR4orpk4PET2"
    },
    {
        "Name": "Kanye West prod. B.o.B",
        "id": "5wUrFJpvNRKTXfV7lqDo2a"
    }
]
""".data(using: .utf8)!
    
    typealias ArtistQuery = [ArtistQueryElement]
    
    struct ArtistQueryElement: Decodable {
        let name, id: String
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case id
        }
    }
    
    func makeStructForArtistQuery(){
        let artistQuery = try? JSONDecoder().decode(ArtistQuery.self, from: artistQueryJSON)
        print(artistQuery!)
    }
    
}


