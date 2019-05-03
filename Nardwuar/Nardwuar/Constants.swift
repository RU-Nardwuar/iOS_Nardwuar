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
        static let primaryColor = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0) //orange

        //grey color
        static let textColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0) //platinum
        
        //for buttons
        static let buttonColor = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0) //orange
        static let buttonText = UIColor(red:0.25, green:0.21, blue:0.21, alpha:1.0) //grey
        //for navigation bar
        static let navBarBackground = UIColor(red:0.25, green:0.21, blue:0.21, alpha:1.0) //grey
        static let navBarLabelActive = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0) //orange
        static let navBarLabelPassive = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0) //platinum
        //for gradients
        static let princetonOrange = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0).cgColor
        static let oxfordBlue = UIColor(red:1.00, green:0.85, blue:0.42, alpha:1.0).cgColor
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
