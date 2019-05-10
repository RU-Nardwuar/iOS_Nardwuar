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
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    var artistKeyArray:[String]?
//Load page
    override func viewDidLoad() {
        print("**** Home Controller: viewDidLoad(), loading page")
        super.viewDidLoad()
        assignUserFromGoogle()
        
        let loader = loadingUI()
        let percentageLabel = loader.returnPercentLabel()
        let trackLayer = loader.returnTrackLayer()
        let shapeLayer = loader.returnShapeLayer()
        blurView.addSubview(percentageLabel)
        blurView.layer.addSublayer(trackLayer)
        blurView.layer.addSublayer(shapeLayer)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("**** Home Controller: viewWillAppear(), resetting tappedArtistID")
        artistID = ""
        artistName = ""
        print("**** Home Controller: going to reload tableView in case any new follows/unfollows")
        tableView.reloadData()
        //blurBackground.isHidden = false
        self.startDispatch(route: "user")
    }
//Post User / Get User
    func assignUserFromGoogle(){
        Constants.structUserData.globalEmail = (GIDSignIn.sharedInstance()?.currentUser.profile.email!)!
        Constants.structUserData.globalPhoto = (Auth.auth().currentUser?.photoURL!)!
        
        print("**** Home Controller: assignUserFromGoogle(), trying to register user/get user info")
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                print("**** Home Controller: could not get user token from google\(error)")
                return
            }
            else{
                print("**** Home Controller: token to register user... \(String(describing: token))")
                self.userToken = token!
                Constants.structUserData.globalIdToken = token!
                //let firstName = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName!)!
                //let displayName = (Auth.auth().currentUser?.displayName!)!
                ////************ get correct arguments for post request
                //self.networkingClient.POSTfirstTimeUser(uid: self.userToken, name: firstName, username: displayName)
                self.startDispatch(route: "user") //after finish calls setupTableView() and setupUI()
            }
        })
    }
//Setup Tableview
    @IBOutlet weak var tableView: UITableView!
    func setupTableView(){
        print("**** Home Controller: setupTableView(), setting table delegates")
        tableView.delegate = self
        tableView.dataSource = self
        if(currentUser?.followedArtists.count == 0){
            tableView.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath)
        let id = currentUser?.followedArtists[indexPath.row].artistID
        cell.textLabel?.text = currentUser?.followedArtists[indexPath.row].artistName
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.clear
        
        //guard let newKeyToAdd = currentUser?.followedArtists[indexPath.row].artistName else {}
        print("**** Home Controller: going to add key \(String(describing: currentUser?.followedArtists[indexPath.row].artistID)) into the array used to compare followed/unfollowed artist page")
        if artistKeyArray?.append(id!) == nil {
            artistKeyArray = ([id] as! [String])
        }
        print("**** Home Controller: current key array \(artistKeyArray)")
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
        navigationController?.navigationBar.barTintColor = Constants.DefaultUI.navBarBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.DefaultUI.navBarLabelPassive]
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

//Two ways to get to Artist Page, case i) user -> searchbar ... case ii) user -> tableview cell
    var artistID = ""
    var artistName = ""
    var userToken = ""
    var currentUser: HomeViewController.UserInfo?
    var artistList: HomeViewController.ArtistQueryList?
    //case i
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("**** Home Controller: in searchbar clicked ... \(searchBar.text!)")
        artistName = searchBar.text!
        print("**** Home Controller: artistName ... \(String(describing: artistName))")
        print("**** Home Controller: starting dispatch with artist route")
        startDispatch(route: "artist") //after finish calls setQuery()
        searchBar.resignFirstResponder()
    }
    
    //case ii
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setQuery(ID: (currentUser?.followedArtists[indexPath.row].artistID)!)
    }
    func setQuery(ID:String){
        artistID = ID
        print("**** Home Controller: setQuery() with tappedArtistID ... \(String(describing: artistID))")
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("**** Home Controller: preparing segue for artist page")
        if segue.identifier == "fromHomeToArtist"{
            guard let destination = segue.destination as? ArtistViewController else {return}
            destination.artistID = artistID
            destination.currentUserToken = currentUser?.id
            print("**** Home Controller: destination.artistID = \(destination.artistID)")
            
            print("**** Home Controller: checking if artist page will be someone they are already following")
            print("**** Home Controller: what I am comparing ... \(artistKeyArray) ... and ... \(artistID)")
            guard let isUserFollowingAlready = artistKeyArray?.contains(artistID) else { print("**** Home Controller: failed to return a bool for if artist is followed already");return}
            print("**** Home Controller: artist followed already? \(isUserFollowingAlready)")
            if(isUserFollowingAlready == true){
                destination.isArtistAlreadyFollowed = true
            }
        }
    }

//Segue Page
    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("**** Home Controller: logout button tapped")
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("**** Home Controller: signed out of google, performing segue to login page")
        performSegue(withIdentifier: "fromHomeToLogin", sender: self)
    }
    func handleProfileSegue(){
        print("**** Home Controller: performing segue to profile page")
        performSegue(withIdentifier: "fromHomeToProfile", sender: self)
    }
    func handleSettingSegue(){
        print("**** Home Controller: performing segue to settings page")
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
    func startDispatch(route:String){
        print("**** Home Controller: startDispatch() with route \(route)")
        let myGroup = DispatchGroup()
        
        if route == "user"{
            for _ in 0 ..< 2 {
                print("**** Home Controller: in user route with link ... ")
                myGroup.enter()
                let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(userToken)"
                print("**** Home Controller: in user route with link ... \(urlString)****")
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
                self.setupTableView()
                self.setupUI()
                //self.blurBackground.isHidden = true
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
                            self.artistID = self.artistList!.artistQueryList[0].id
                        } catch let jsonErr {
                            print("Failed to decode:", jsonErr)
                        }
                    }
                    myGroup.leave()
                    }.resume()
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                print("**** Home Controller: artistID sent to setQuery() ... \(String(describing: self.artistID))")
                self.setQuery(ID: self.artistID)
            }
        }
    }
}
