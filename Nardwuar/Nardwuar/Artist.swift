//
//  Artist.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/15/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation

struct artistData{
    let userIsFollowing:Bool
    let stageName:String
    let mainGenre:String
    let doesArtistHaveMultipleNames:Bool
        let alternativeNames:[String]?
    let doesArtistHaveLegalName:Bool
        let legalName:String?
    let dateBorn:String
    let cityBorn:String
    let stateBorn:String
    let proPic:URL
    let doesArtistHaveAwards:Bool
        let awards:[String]?
    let mostRecentSong:String
    let mostPopularSong:String
}

