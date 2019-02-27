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
        
//        //logout button
//        let logoutButton = UIButton(type: .system)
//        logoutButton.setImage( UIImage(named: "icons8-cancel-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        logoutButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
//        
//        //searchbar
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.searchBar.setImage(UIImage(named: "icons8-music-100"), for: UISearchBar.Icon.search, state: .normal)
//        searchController.searchBar.setImage(UIImage(named: "icons8-cancel-50"), for: UISearchBar.Icon.clear, state: .normal)
//        //        searchController.searchBar.barTintColor = .white
//        //        searchController.searchBar.tintColor = .white
//        //        searchController.searchBar.isTranslucent = false
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for an Artist...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        
//        //profile button
//        let profileButton = UIButton(type: .system)
//        profileButton.setImage( UIImage(named: "icons8-contacts-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        profileButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
//        
//        searchController.searchBar.tintColor = .white
    }
    

}
