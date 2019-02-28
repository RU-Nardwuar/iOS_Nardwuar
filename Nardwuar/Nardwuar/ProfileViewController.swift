//
//  ProfileViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButtons()
    }
    
    func setupNavigationButtons(){
        
        let fullName = UILabel()
        fullName.text = "Xavier La Rosa"
        navigationItem.title = fullName.text
        
    }
    

}
