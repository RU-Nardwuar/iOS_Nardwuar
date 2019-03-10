//
//  HomeViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

struct structUserData {
    static var globalUID: String?
    static var globalPhoto: URL?
    static var globalEmail: String?
    static var globalGivenName: String?
    static var globalFamilyName: String?
    static var globalDisplayName: String?
    static var globalFollowedArtists:[String] = []
}

class HomeViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate {
//************
    //3.8.19: UNCOMMENT ALL COMMENTS ONCE LOGIN CONTROLLER IS FIXED
    
    @IBOutlet weak var logoutButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    @IBOutlet weak var infoButton: UITabBarItem!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        setupPage()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.0
        }
        return UITableView.automaticDimension
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(structUserData.globalFollowedArtists.count == 0){
            tableView.isHidden = true
            
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func setupPage(){
        setUpUserData()
        setupNavigationBarItems()
    }
//SETUP UI
    var email = ""
    var displayName = ""
    var userIdToken: String?
    func setUpUserData(){
        email = (GIDSignIn.sharedInstance()?.currentUser.profile.email!)!
        displayName = (Auth.auth().currentUser?.displayName!)!
        structUserData.globalUID = (Auth.auth().currentUser?.uid)!
        structUserData.globalPhoto = (Auth.auth().currentUser?.photoURL!)!
        setupNavigationBarItems()
        //This is how we get the idToken to send to the server
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                print(error)
                return
            }
            //print("TOKEN TO SEND TO BACKEND:\(token)") //connect with backend in here
            self.userIdToken = token
        })
        
        print("**** User Data: \(email)\(displayName)")
        structUserData.globalDisplayName = displayName
        structUserData.globalEmail = email
    }
    func setupNavigationBarItems(){
        setupLogoutButton()
        setupSearchBar()
        setupProfileButton()
    }
    
//SETUP NAVIGATION OBJECTS
    //let logoutButton = UIButton(type: .system)
    func setupLogoutButton(){//LOGOUT
//        logoutButton.setImage( UIImage(named: "icons8-cancel-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        logoutButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
//        logoutButton.addTarget(self, action: #selector(handleLogoutSegue(sender:)), for: .touchUpInside)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    func setupSearchBar(){//SEARCHBAR
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.setImage(UIImage(named: "icons8-music-100"), for: UISearchBar.Icon.search, state: .normal)
        searchController.definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for an Artist...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.33, green:0.30, blue:0.34, alpha:1.0)
            ])
    }
    
    //let profileButton = UIButton(type: .system)
    func setupProfileButton(){//PROFILE
//        profileButton.setImage( UIImage(named: "icons8-contacts-50")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        profileButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
//        profileButton.addTarget(self, action: #selector(handleProfileSegue(sender:)), for: .touchUpInside)
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
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "fromHomeToLogin", sender: self)
    }
    
}
extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
//extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
//
//
//}
