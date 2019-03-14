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
    static let primaryColor = UIColor(red:0.77, green:1.00, blue:0.98, alpha:1.0)
    //grey color
    static let secondaryColor = UIColor(red:0.33, green:0.30, blue:0.34, alpha:1.0)
    //green color
    static let highlightColor = UIColor(red:0.53, green:1.00, blue:0.68, alpha:1.0)
}

struct structUserData {//Global Variables for User
    static var globalUID: String?
    static var globalPhoto: URL?
    static var globalEmail: String?
    static var globalGivenName: String?
    static var globalFamilyName: String?
    static var globalDisplayName: String?
    static var globalFollowedArtists:[String] = []
}

}
