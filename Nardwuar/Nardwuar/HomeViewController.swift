//
//  HomeViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
    }
//SETUP UI
    func setupNavigationBarItems(){
        setupLogoutButton()
        setupSearchBar()
        setupProfileButton()
    }
    
//UI FUNCTIONS
    let logoutButton = UIButton(type: .system)
    func setupLogoutButton(){//LOGOUT
        logoutButton.setImage( UIImage(named: "icons8-cancel-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        logoutButton.addTarget(self, action: #selector(handleLogoutSegue(sender:)), for: .touchUpInside)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    func setupSearchBar(){//SEARCHBAR
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setImage(UIImage(named: "icons8-music-100"), for: UISearchBar.Icon.search, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for an Artist...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    let profileButton = UIButton(type: .system)
    func setupProfileButton(){//PROFILE
        profileButton.setImage( UIImage(named: "icons8-contacts-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profileButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        profileButton.addTarget(self, action: #selector(handleProfileSegue(sender:)), for: .touchUpInside)
    }
    
//SEGUES
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("in searchbar clicked")
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
    }
    @objc func handleProfileSegue(sender: UIButton){
        print("Profile segue method")
        performSegue(withIdentifier: "fromHomeToProfile", sender: self)
    }
    
    @objc func handleLogoutSegue(sender: UIButton){
        print("Logout segue method")
        performSegue(withIdentifier: "fromHomeToLogin", sender: self)
    }
    
}
