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

class HomeViewHeadlineTableViewCell: UITableViewCell {
    
   // @IBOutlet weak var viewButton: UIButton!
   // @IBOutlet weak var artistLabel: UILabel!
    
    
    }
class HomeViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate {
//Struct Section
    struct CurrentUser: Codable {
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
//load page
    override func viewDidLoad() {
        super.viewDidLoad()
        assignVarFromGoogle()
        startDispatch()
    }
    //SETUP USER DATA AND CONNECT TO SERVER
    func assignVarFromGoogle(){
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
            print("**** TOKEN: \(String(describing: token))")
            self.userID = token!
            let firstName = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName!)!
            let displayName = (Auth.auth().currentUser?.displayName!)!
            self.networkingClient.POSTfirstTimeUser(uid: userIdToken!, name: firstName, username: displayName)
        })
        
    }
    //FETCH
    var userID = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjY1NmMzZGQyMWQwZmVmODgyZTA5ZTBkODY5MWNhNWM3ZjJiMGQ2MjEiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiWEFWSUVSIExBIFJPU0EiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1Dbk5LNkVjVHpJQS9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBYy9EU2NwR0s5d1U1RS9zOTYtYy9waG90by5qcGciLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbmFyZHd1YXItN2U2ZmMiLCJhdWQiOiJuYXJkd3Vhci03ZTZmYyIsImF1dGhfdGltZSI6MTU1NjE0MjAyMiwidXNlcl9pZCI6Ik1Jc2ZnVEJ0dnNTUlB0eEZhdlNjYlFaTXE2QTIiLCJzdWIiOiJNSXNmZ1RCdHZzU1JQdHhGYXZTY2JRWk1xNkEyIiwiaWF0IjoxNTU2MTQyMDIzLCJleHAiOjE1NTYxNDU2MjMsImVtYWlsIjoieGxyMUBzY2FybGV0bWFpbC5ydXRnZXJzLmVkdSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTE1MDkyMDk5NDYwMTcxNTk2NTQ3Il0sImVtYWlsIjpbInhscjFAc2NhcmxldG1haWwucnV0Z2Vycy5lZHUiXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.sxJHwsuUHi-ENZL1FfB7Mtt7Aj3ywujjj0A9CfIMrpxUaw0t_tXTpLLu3BnjbfRShOnA4Eb4YHmTFB1S5fZb5xLEzKjOsJMXUhlwWIEzFDx2Td95McpE6Vz_hAF_XyWyiCwCwH1MZu7p73kMhppYWRpYYmJiy5R81AweyaZjZPQhe_6KlDffDJrZ5a2AxOzo_aOhoYV5TyX2p_jow7Su2-c95e33ONhCD7icX3pSjkCpu25yONkwPBSF3SszgyXeW0OBI1Wv561XUA7R7sHGWOGm3kScb2jxtYU8KNOL1qUJTbcpNULYLWmRTjVWYsIU4ig8RQx3QiVYh4gV9SGcJQ"
    var currentUser: HomeViewController.CurrentUser?
    func startDispatch(){
        let myGroup = DispatchGroup()
        
        for _ in 0 ..< 5 {
            myGroup.enter()
            let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(userID)"
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        print("Failed to get data from url:", err)
                        return
                    }
                    
                    guard let data = data else { return }
                    print("**** DATA IN HOME: \(data)")
                    do {
                        // link in description for video on JSONDecoder
                        let decoder = JSONDecoder()
                        // Swift 4.1
                        //decoder.keyDecodingStrategy = .convertFromSnakeCase
                        self.currentUser = try decoder.decode(CurrentUser.self, from: userJSONDataLocal)
                        self.tableView.reloadData()
                        print("**** CURRENT USER INFO: \(String(describing: self.currentUser?.followedArtists))")
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
            self.debug()

        }
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    func debug(){
        // print("**** DEBUG \(currentArtist?.spotify.artistName)")
    }
    //SEGUES FOR SEARCHBAR AND TAB BAR BUTTONS
    let networkingClient = NetworkingClient()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("in searchbar clicked")
        networkingClient.GETfirstFiveArtistData(searchBar.text!)
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
    }
    //SETUP PAGE
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
    

    
    
    
    
    
    
//TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath) as! HomeViewHeadlineTableViewCell
        cell.textLabel?.text = currentUser?.followedArtists[indexPath.row].artistName
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.clear
        
       //cell.viewButton.layer.cornerRadius = cell.viewButton.frame.height/2
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath) as! HomeViewHeadlineTableViewCell
        setQuery(x: (currentUser?.followedArtists[indexPath.row].artistID)!)
        
        
    }
    
    
    var tappedArtistID = ""
    func setQuery(x:String){
        
        tappedArtistID = x
        performSegue(withIdentifier: "fromHomeToArtist", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PERFORMING SEGUE----")
        if segue.identifier == "fromHomeToArtist"{
            guard let destination = segue.destination as? ArtistViewController else {return}
            
            destination.artistID = tappedArtistID//if searchbar tapped
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tappedArtistID = ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
}


let userJSONDataLocal = """
{
        "FollowedArtists": [
            {
                "artist_id": "7rCpeQgJIrKKo6gubCkMDK",
                "artist_name": "Young Jeezy & Kanye"
            },
            {
                "artist_id": "20wkVLutqVOYrc0kxFs7rA",
                "artist_name": "Daniel Caesar"
            },
            {
                "artist_id": "7n2wHs1TKAczGzO7Dd2rGr",
                "artist_name": "Shawn Mendes"
            },
            {
                "artist_id": "5K4W6rqBFWDnAN6FQUkS6x",
                "artist_name": "Kanye West"
            },
            {
                "artist_id": "3fMbdgg4jU18AjLCKBhRSm",
                "artist_name": "Michael Jackson"
            },
            {
                "artist_id": "74ASZWbe4lXaubB36ztrGX",
                "artist_name": "Bob Dylan"
            },
            {
                "artist_id": "66CXWjxzNUsdJxJ2JdwvnR",
                "artist_name": "Ariana Grande"
            },
            {
                "artist_id": "3gMaNLQm7D9MornNILzdSl",
                "artist_name": "Lionel Richie"
            },
            {
                "artist_id": "5IcR3N7QB1j6KBL8eImZ8m",
                "artist_name": "ScHoolboy Q"
            },
            {
                "artist_id": "13ubrt8QOOCPljQ2FL1Kca",
                "artist_name": "A$AP Rocky"
            },
            {
                "artist_id": "7yO4IdJjCEPz7YgZMe25iS",
                "artist_name": "A$AP Mob"
            },
            {
                "artist_id": "30DhU7BDmF4PH0JVhu8ZRg",
                "artist_name": "Sabrina Claudio"
            }
        ],
        "Name": "XAVIER",
        "Username": "XAVIER LA ROSA",
        "_id": "MIsfgTBtvsSRPtxFavScbQZMq6A2"
    }
""".data(using: .utf8)!


/*
 struct ArtistQuery: Codable {
 let artistQueryList: [ArtistQueryList]
 }
 
 struct ArtistQueryList: Codable {
 let name, id: String
 
 enum CodingKeys: String, CodingKey {
 case name = "Name"
 case id
 }
 }
 
 
 
 {
 "artistQueryList":[
 {
 "Name": "Sabrina Carpenter",
 "id": "74KM79TiuVKeVCqs8QtB0B"
 },
 {
 "Name": "Sabrina Claudio",
 "id": "30DhU7BDmF4PH0JVhu8ZRg"
 },
 {
 "Name": "Sabrina Claudio vs.",
 "id": "5byCrf0f6cosaURjAS899Z"
 },
 {
 "Name": "Cast of Chilling Adventures of Sabrina",
 "id": "4Y43D0ynLoyZ3HxOPGxxFq"
 },
 {
 "Name": "Sabrina Signs",
 "id": "30XgRdKEsS1c8RkOYYiTbu"
 }
 ]
 }
 
 */
