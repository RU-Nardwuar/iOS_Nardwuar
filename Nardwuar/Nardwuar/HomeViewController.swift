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
//Debug function
    func debug(){
        print("**** Home Controller: DEBUG \(String(describing: currentUser?.followedArtists))")
    }
//Setup Tablview
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
//Load page
    override func viewDidLoad() {
        print("**** Home Controller: loading page")
        super.viewDidLoad()
        assignUserFromGoogle()
    }
    override func viewWillAppear(_ animated: Bool) {
        tappedArtistID = ""
    }
//Get user from google, send to token to backend function
    func assignUserFromGoogle(){
        Constants.structUserData.globalEmail = (GIDSignIn.sharedInstance()?.currentUser.profile.email!)!
        Constants.structUserData.globalPhoto = (Auth.auth().currentUser?.photoURL!)!
        
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                print("**** Home Controller: could not get user token from google\(error)")
                return
            }
            else{
                print("**** Home Controller: token to register user... \(String(describing: token))")
                self.userToken = token!
                //let firstName = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName!)!
                //let displayName = (Auth.auth().currentUser?.displayName!)!
                ////************ get correct arguments for post request
                //self.networkingClient.POSTfirstTimeUser(uid: self.userToken, name: firstName, username: displayName)
                self.startDispatch(route: "user")
            }
        })
    }
//SEGUES FOR SEARCHBAR AND TAB BAR BUTTONS
    var artistName = "Kanye West"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("**** Home Controller: in searchbar clicked ... \(searchBar.text!)")
        artistName = searchBar.text!
        print("**** Home Controller: artistName ... \(artistName)")
        print("**** Home Controller: starting dispatch with artist route")
        startDispatch(route: "artist")
        searchBar.resignFirstResponder()
    }
//Setup UI
    @IBOutlet weak var emptyTableText: UILabel!
    @IBOutlet weak var searchController: UISearchBar!
    func setupUI(){
        self.view.backgroundColor = Constants.DefaultUI.primaryColor
        emptyTableText.textColor = Constants.DefaultUI.textColor
        searchController.showsScopeBar = true
        searchController.delegate = self
        searchController.tintColor = Constants.DefaultUI.primaryColor
        searchController.barTintColor = Constants.DefaultUI.primaryColor
        searchController.setImage(UIImage(named: "icons8-music-100"), for: UISearchBar.Icon.search, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for an Artist...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.33, green:0.30, blue:0.34, alpha:1.0)
            ])
        navigationController?.navigationBar.barTintColor = Constants.DefaultUI.primaryColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.DefaultUI.textColor]
        for subView in searchController.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UINavigationButton")!) {
                    let cancelButton = view as! UIButton
                    cancelButton.setTitleColor(Constants.DefaultUI.textColor, for: .normal)
                }
                if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    let imageView = view as! UIImageView
                    imageView.removeFromSuperview()
                }
            }
        }
        tableView.backgroundColor = UIColor.clear
    }
 
//Tableview
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath)
        cell.textLabel?.text = currentUser?.followedArtists[indexPath.row].artistName
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.clear

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (currentUser?.followedArtists.count == 0) {
            return 0.0
        }
        return 80.0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentUser?.followedArtists.count)!
    }
    
//Cell or view button tapped
    var tappedArtistID = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setQuery(artistID: (currentUser?.followedArtists[indexPath.row].artistID)!)
    }
    func setQuery(artistID:String){
        tappedArtistID = artistID
        print("**** Home Controller: setQuery() with tappedArtistID ... \(tappedArtistID)")
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("**** Home Controller: preparing segue for artist page")
        if segue.identifier == "fromHomeToArtist"{
            guard let destination = segue.destination as? ArtistViewController else {return}
            destination.artistID = tappedArtistID
            print("**** Home Controller: destination.artistID = \(destination.artistID)")
        }
    }

//Segue Page
    @IBAction func logoutButtonTapped(_ sender: Any) {
        handleLogoutSegue()
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
    
//Struct for user info
    struct UserInfo: Codable {
        let followedArtists: [FollowedArtist]
        let name, username, id: String
        
        enum CodingKeys: String, CodingKey {
            case followedArtists = "FollowedArtists"
            case name = "Name"
            case username = "Username"
            case id = "_id"
        }
    }
    
    struct FollowedArtist: Codable {
        let artistID, artistName: String
        
        enum CodingKeys: String, CodingKey {
            case artistID = "artist_id"
            case artistName = "artist_name"
        }
    }
//Struct for artist query
    struct ArtistQueryList: Codable {
        let artistQueryList: [ArtistQueryListElement]
    }
    
    struct ArtistQueryListElement: Codable {
        let name, id: String
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case id
        }
    }

//Get method
    var userToken = "Default"
    var currentUser: HomeViewController.UserInfo?
    var artistList: HomeViewController.ArtistQueryList?
    func startDispatch(route:String){
        let myGroup = DispatchGroup()
        
        if route == "user"{
            for _ in 0 ..< 5 {
                myGroup.enter()
                let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(userToken)"
                guard let url = URL(string: urlString) else { return }
                URLSession.shared.dataTask(with: url) { (data, _, err) in
                    DispatchQueue.main.async {
                        if let err = err {
                            print("Failed to get data from url:", err)
                            return
                        }
                        
                        guard let data = data else { return }
                        print("**** ARTIST PAGE DATA: \(data)")
                        do {
                            let decoder = JSONDecoder()
                            self.currentUser = try decoder.decode(UserInfo.self, from: data)
                            print("**** CURRENT ARTIST INFO: \(String(describing: self.currentUser))")
                            self.tableView.reloadData()
                        } catch let jsonErr {
                            print("Failed to decode:", jsonErr)
                        }
                    }
                    myGroup.leave()
                    }.resume()
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                self.debug()
                self.setupTableView()
                self.setupUI()
            }
        } else if route == "artist"{
            for _ in 0 ..< 5 {
                myGroup.enter()
                let urlString = "https://nardwuar.herokuapp.com/search?query=\(artistName)"
                print("**** Home Controller: get artist query link... \(urlString)")
                guard let url = URL(string: urlString) else { return }
                URLSession.shared.dataTask(with: url) { (data, _, err) in
                    DispatchQueue.main.async {
                        if let err = err {
                            print("Failed to get data from url:", err)
                            return
                        }
                        
                        guard let data = data else { return }
                        print("**** ARTIST PAGE DATA: \(data)")
                        do {
                            let decoder = JSONDecoder()
                            self.artistList = try decoder.decode(ArtistQueryList.self, from: data)
                            print("**** CURRENT ARTIST INFO: \(String(describing: self.artistList!.artistQueryList[0]))")
                            //self.tableView.reloadData()
                            self.tappedArtistID = self.artistList!.artistQueryList[0].id
                        } catch let jsonErr {
                            print("Failed to decode:", jsonErr)
                        }
                    }
                    myGroup.leave()
                    }.resume()
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                print("**** Home Controller: artistID sent to setQuery() ... \(self.tappedArtistID)")
                self.setQuery(artistID: self.tappedArtistID)
            }
        }
    }
}
