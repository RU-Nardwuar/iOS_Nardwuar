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
import Alamofire

class HomeViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate {
//ON LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
//SETUP PAGE
    @IBOutlet weak var emptyTableText: UILabel!
    func setupPage(){
        self.view.backgroundColor = Constants.DefaultUI.primaryColor
        emptyTableText.textColor = Constants.DefaultUI.textColor
        
        setUpUserData()
        setupSearchBar()
        setupTableView()
        setupTabBar()
    }
//API REQUEST FOR ACCOUNT DATA
    private let networkingClient = NetworkingClient()
    
    func getUserData(token:String){
        self.networkingClient.GETaccountData(token)
        //constants should all be set now, you can then use user data for any page!
    }
//SETUP USER DATA AND CONNECT TO SERVER
    func setUpUserData(){
        //set misc constants
        Constants.structUserData.globalEmail = (GIDSignIn.sharedInstance()?.currentUser.profile.email!)!
        Constants.structUserData.globalPhoto = (Auth.auth().currentUser?.photoURL!)!
        
        
        //send token, firstname, displayname to post request
        //call getUserData function with token
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                print(error)
                return
            }
            //print("TOKEN TO SEND TO BACKEND:\(token)") //connect with backend in here
            let userIdToken = token
            let firstName = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName!)!
            let displayName = (Auth.auth().currentUser?.displayName!)!
            self.networkingClient.POSTfirstTimeUser(uid: userIdToken!, name: firstName, username: displayName)
            self.getUserData(token: token!)
        })
        
    }
//SEARCHBAR
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
//TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        if(Constants.structUserData.globalFollowing.count == 0){
            tableView.isHidden = true
        }
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
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//TAB BAR
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var logoutButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    @IBOutlet weak var infoButton: UITabBarItem!
    func setupTabBar(){
        self.tabBar.delegate = self
        tabBar.barTintColor = Constants.DefaultUI.primaryColor //Cyan
        tabBar.backgroundColor = Constants.DefaultUI.primaryColor
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag  {
        case 0:
            handleLogoutSegue()
            break
        case 1:
            handleProfileSegue()
            break
        case 2:
            handleSettingSegue()
            break
        default:
            handleLogoutSegue()
            break
        }
    }
//SEGUES FOR SEARCHBAR AND TAB BAR BUTTONS
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("in searchbar clicked")
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
    }
    func handleLogoutSegue(){
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
    func handleProfileSegue(){
        print("Profile segue method")
        performSegue(withIdentifier: "fromHomeToProfile", sender: self)
    }
    func handleSettingSegue(){
        print("Setting segue method")
        performSegue(withIdentifier: "fromHomeToSetting", sender: self)
    }
}
