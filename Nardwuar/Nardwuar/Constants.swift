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
        static let buttonColor = UIColor(red:0.63, green:0.96, blue:0.58, alpha:1.0) //green
        //grey color
        static let textColor = UIColor(red:0.25, green:0.21, blue:0.21, alpha:1.0) //grey
        
        
        static let princetonOrange = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0).cgColor
        static let oxfordBlue = UIColor(red:1.00, green:0.82, blue:0.30, alpha:1.0).cgColor
        static let rajah = UIColor(red:1.00, green:0.73, blue:0.37, alpha:1.0).cgColor
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
