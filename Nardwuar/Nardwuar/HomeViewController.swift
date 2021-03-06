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

class HomeViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate, URLSessionDownloadDelegate  {

    var artistKeyArray:[String]?
//load page
    override func viewDidLoad() {
        print("**** Home Controller: viewDidLoad(), loading page")
        super.viewDidLoad()
        assignUserFromGoogle()
        setupLoadUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("**** Home Controller: viewWillAppear(), resetting tappedArtistID")
        artistID = ""
        artistName = ""
        print("**** Home Controller: going to reload tableView in case any new follows/unfollows")
        tableView.reloadData()
        loadingView.isHidden = false
        self.startDispatch(route: "user")
    }
//load UI
    @IBOutlet weak var loadingView: UIView!
    var loader:loadingUI?
    var percentageLabel:UILabel?
    var trackLayer:CAShapeLayer?
    var shapeLayer:CAShapeLayer?
    func setupLoadUI(){
        loader = loadingUI()
        percentageLabel = loader?.returnPercentLabel()
        trackLayer = loader?.returnTrackLayer()
        shapeLayer = loader?.returnShapeLayer()
        guard let perc = percentageLabel else {return}
        guard let track = trackLayer else {return}
        guard let shape = shapeLayer else {return}
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.DefaultUI.oxfordBlue, Constants.DefaultUI.princetonOrange]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        loadingView.layer.addSublayer(gradientLayer)
        loadingView.addSubview(perc)
        loadingView.layer.addSublayer(track)
        loadingView.layer.addSublayer(shape)
    }
//animate load
    func animateLoad(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.5
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            UIView.animate(withDuration: animationDuration, delay: delay, options: [], animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }
//POST User with NetworkingClient() and call get user route
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
                    
                    self.percentageLabel?.text = "Welcome"
                    self.animateLoad(view: self.loadingView, delay: 1.0)
                    //self.navigationController?.navigationBar.isHidden = false
                    //self.loadingView.isHidden = true
                }
            }
        })
    }
//Setup UI
    @IBOutlet weak var searchController: UISearchBar!
    func setupUI(){
        
        self.view.backgroundColor = Constants.DefaultUI.primaryColor
        navigationController?.navigationBar.barTintColor = Constants.DefaultUI.navBarBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.DefaultUI.navBarLabelPassive]
        
        searchController.showsScopeBar = true
        searchController.delegate = self
        searchController.tintColor = Constants.DefaultUI.primaryColor
        searchController.barTintColor = Constants.DefaultUI.primaryColor
        searchController.setImage(UIImage(named: "icons8-music-100"), for: UISearchBar.Icon.search, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for an Artist...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.33, green:0.30, blue:0.34, alpha:1.0)
            ])
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath as IndexPath) as! HeadlineTableViewCell
        let id = currentUser?.followedArtists[indexPath.row].artistID
        cell.homeArtistLabel.text = currentUser?.followedArtists[indexPath.row].artistName
        cell.homeArtistLabel.font = UIFont(name: "Avenir", size: 20.0)
        cell.homeArtistLabel.textColor = UIColor.white
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.clear
        cell.homeViewButton.layer.masksToBounds = false
        cell.homeViewButton.layer.cornerRadius = cell.homeViewButton.frame.height/2
        
        //guard let newKeyToAdd = currentUser?.followedArtists[indexPath.row].artistName else {}
        print("**** Home Controller: going to add key \(String(describing: currentUser?.followedArtists[indexPath.row].artistID)) into the array used to compare followed/unfollowed artist page")
        if artistKeyArray?.append(id!) == nil {
            artistKeyArray = ([id] as! [String])
        }
        print("**** Home Controller: current key array \(String(describing: artistKeyArray))")
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
//Two ways to get to Artist Page, case i) user -> searchbar ... case ii) user -> tableview cell
    var artistID = "", artistName = "", userToken = "", currentUser: HomeViewController.UserInfo?, artistList: HomeViewController.ArtistQueryList?
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
            guard let id = currentUser?.id else {return}
            destination.currentUserToken = id
            print("**** Home Controller: destination.artistID = \(destination.artistID)")
            
            print("**** Home Controller: checking if artist page will be someone they are already following")
            print("**** Home Controller: what I am comparing ... \(String(describing: artistKeyArray)) ... and ... \(artistID)")
            guard let isUserFollowingAlready = artistKeyArray?.contains(artistID) else { print("**** Home Controller: failed to return a bool for if artist is followed already");return}
            print("**** Home Controller: artist followed already? \(isUserFollowingAlready)")
            if(isUserFollowingAlready == true){
                destination.isArtistAlreadyFollowed = true
            }
        }
    }
//Logout
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
    
//ROUTE RELATED
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
//Get method: case i) user route ... case ii) artist route
    func startDispatch(route:String){
        print("**** Home Controller: startDispatch() with route \(route)")
        let myGroup = DispatchGroup()
        
        if route == "user"{
            shapeLayer?.strokeEnd = 0
            
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(userToken)"
            print("**** Home Controller: in user route with link ... \(urlString)****")
            guard let url = URL(string: urlString) else { return }
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
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
//Get method: for user route with dynamic percent loader
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let myGroup = DispatchGroup()
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        for _ in 0 ..< 3 {
            
            let urlString = "https://nardwuar.herokuapp.com/users?id_token=\(userToken)"
            print("**** Home Controller: in user route with link ... \(urlString)****")
            guard let url = URL(string: urlString) else { return }
            print("**** Home Controller: in user route with link ... ")
            myGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, _, err) in
                DispatchQueue.main.async {
                    self.percentageLabel?.text = "\(Int(percentage * 100))%"
                    self.shapeLayer?.strokeEnd = percentage
                    if let err = err {
                        print("Failed to get data from url:", err)
                        return
                    }
                    
                    guard let data = data else { return }
                    print("**** USER PAGE DATA: \(data)")
                    do {
                        let decoder = JSONDecoder()
                        self.currentUser = try decoder.decode(UserInfo.self, from: data)
                        print("**** CURRENT USER INFO: \(String(describing: self.currentUser))")
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
        }
        print(percentage)
    }
    //protocol we must always have when download done for user route
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
}
