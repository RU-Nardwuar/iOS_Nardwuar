//
//  Constants.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/28/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation
import UIKit

public class Constants{
    enum DefaultUI {
        
        //cyan color
        static let primaryColor = UIColor(red:0.77, green:1.00, blue:0.98, alpha:1.0) //cyan
        //cyan color
        static let primaryColorOpacity = UIColor(red:0.77, green:1.00, blue:0.98, alpha:0.5) //cyan
        //green color
        static let buttonColor = UIColor(red:0.63, green:0.96, blue:0.58, alpha:1.0) //darker cyan
        //grey color
        static let textColor = UIColor(red:0.33, green:0.30, blue:0.34, alpha:1.0) //grey
    }

    struct structUserData {//Global Variables for User
        static var globalIdToken: String?
        static var globalName: String?
        static var globalUsername: String?
        static var globalFollowing:[Account.FollowedArtist]?
        static var globalPhoto: URL?
        static var globalEmail: String?
    }
    
    struct structArtistData {
        static var artistPhoto: String?
        static var artistName: String?
        static var artistFollowers: Int?
        static var artistGenres: [String]?
        static var artistTopAlbums: [Artist.Pitchfork]?
        static var artistTopAlbumsPictures: [String]?
        static var artistAlbums: [String]?
    }
    
}
