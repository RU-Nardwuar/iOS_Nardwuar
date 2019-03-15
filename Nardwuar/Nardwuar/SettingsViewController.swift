//
//  SettingsViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 3/13/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var postLabel: UIButton!
    @IBAction func postTapped(_ sender: Any) {
    }
    var userData = AccountDetails.self
    override func viewDidLoad() {
        super.viewDidLoad()
       // makeRegistrationConnection()
    }
//    func makeRegistrationConnection(){
//        let accountObject = userData
//        AccountDetails.registerFirstTimeUser(token: <#T##String#>)
//    }
}
