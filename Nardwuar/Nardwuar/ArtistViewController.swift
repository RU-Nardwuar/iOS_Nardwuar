//
//  ArtistViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/28/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
    
   // @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var scoreCell: UILabel!
    @IBOutlet weak var albumNameCell: UILabel!
    @IBOutlet weak var albumYearCell: UILabel!
    @IBOutlet weak var albumLabelCell: UILabel!
    @IBOutlet weak var albumAwardCell: UILabel!
    @IBOutlet weak var staticScoreLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
}

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    @IBOutlet weak var followButton: UIButton!
    var currentUserToken:String?
    var isArtistAlreadyFollowed = false
    @IBAction func followButtonTapped(_ sender: UIButton) {
        let networkingClient = NetworkingClient()
        guard let token = Constants.structUserData.globalIdToken else {return}
        guard let artistName = currentArtist?.spotify.artistName else {return}
        if(isButtonHollow == true){
            fillButton()
            networkingClient.POSTfollowNewArtist(token: token, artistName: artistName, artistId: artistID)
        } else{
            hollowButton()
            networkingClient.POSTunfollowNewArtist(token: token, artistName: artistName, artistId: artistID)
        }
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.3, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
    var isButtonHollow = false
    func hollowButton(){
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(Constants.DefaultUI.buttonColor, for: .normal)
        isButtonHollow = true
    }
    func fillButton(){
        //followButton.layer.borderColor = (Constants.DefaultUI.buttonColor as! CGColor)
        followButton.backgroundColor = Constants.DefaultUI.buttonColor
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(Constants.DefaultUI.buttonText, for: .normal)
        isButtonHollow = false
    }
    //ON LOAD
    var artistID = "30DhU7BDmF4PH0JVhu8ZRg"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        loadingText.textColor = Constants.DefaultUI.primaryColor
        startDispatch()
    }
    func setupTableView(){
        blurBackground.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.backgroundView = UIImageView(image: UIImage(named: "homeBackground1"))
    }
    func pageDoneLoading(){
        self.navigationController?.navigationBar.isHidden = false
    }
    //FETCH
    var currentArtist: ArtistViewController.ArtistInfo?
    func startDispatch(){
        let myGroup = DispatchGroup()
        
        for _ in 0 ..< 5 {
            myGroup.enter()
            let urlString = "https://nardwuar.herokuapp.com/artist-info/\(artistID)"
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
                        self.currentArtist = try decoder.decode(ArtistInfo.self, from: data)
                        print("**** CURRENT ARTIST INFO: \(String(describing: self.currentArtist))")
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
            self.debug()
            self.setupProfilePicAndQuickInfo()
            self.setupNavigation()
            self.pageDoneLoading()
        }
    }
    func debug(){
        print("**** DEBUG \(String(describing: currentArtist?.spotify.artistName))")
    }
    //ON LOAD
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    //SETUP UI
        @IBOutlet weak var profilePic: UIImageView!
        @IBOutlet weak var spotifyLabel: UILabel!
        @IBOutlet weak var genreLabel: UILabel!
        @IBOutlet weak var artistLabel: UILabel!
    func setupNavigation(){
            navigationItem.title = "Artist"
        }
        func setupProfilePicAndQuickInfo(){
            
            if(isArtistAlreadyFollowed == true){
                fillButton()
            } else{
                hollowButton()
            }
            followButton.layer.borderWidth = 1.0
            followButton.layer.borderColor = Constants.DefaultUI.buttonColor.cgColor
            
            artistLabel.text = currentArtist?.spotify.artistName
            artistLabel.textColor = UIColor.white
            artistLabel.font = UIFont(name: "Avenir", size: 20.0)
            
            guard let followers = currentArtist?.spotify.totalNumberOfSpotifyFollowers else {return}
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let formattedNumber = numberFormatter.string(from: NSNumber(value: followers)) else {return}
            let followersString = String(formattedNumber)
            spotifyLabel.text = "Spotify Followers | \(followersString)"
            spotifyLabel.textColor = UIColor.white
            
            let strNumber: NSString = "Hello Test" as NSString // you must set your
            let range = (strNumber).range(of: "Test")
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            genreLabel.attributedText = attribute
            
            guard let genres = currentArtist?.spotify.genres else {return}
            genreLabel.text = genres[0]
            genreLabel.textColor = UIColor.white
            
            navigationController?.navigationBar.barTintColor = Constants.DefaultUI.navBarBackground
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.DefaultUI.navBarLabelPassive]
            
            
            tableView.backgroundColor = UIColor.clear
            
            profilePic.layer.borderWidth = 0.25
            profilePic.layer.masksToBounds = false
            profilePic.layer.shadowColor = UIColor.black.cgColor
            profilePic.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            profilePic.layer.shadowRadius = 5.0
            profilePic.layer.shadowOpacity = 0.5
            profilePic.layer.cornerRadius = profilePic.frame.height/2
            profilePic.clipsToBounds = true
            let imgURL = URL(string: (currentArtist?.spotify.artistPhoto600X600)!)
            downloadImage(from: imgURL!)
            
            followButton.layer.masksToBounds = false
            followButton.layer.cornerRadius = followButton.frame.height/2
        }
    //GET PROFILE PIC
        func downloadImage(from url: URL) {
            print("Download Started")
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.profilePic.image = UIImage(data: data)
                }
            }
        }
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
//TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionSize = currentArtist?.pitchfork.count else {return 0}
            return sectionSize
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "artistCell")
//        headerCell?.backgroundColor = Constants.DefaultUI.textColor
//        headerCell?.textLabel?.text = "Recent Albums"
//        headerCell?.textLabel?.textColor = UIColor.white
//        headerCell?.textLabel?.font = UIFont(name: "Avenir", size: 20.0)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 35))
        headerView.backgroundColor = Constants.DefaultUI.textColor
        headerView.layer.borderWidth = 0.25
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = "Recent Albums"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 25.0)
        headerView.addSubview(label)
        return headerView
        
        //return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("**** IN TABLEVIEW")
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! HeadlineTableViewCell
        
            let current = currentArtist?.pitchfork[indexPath.row]
        
            let score:String = String(format:"%.1f", (currentArtist?.pitchfork[indexPath.row].albumScore)!)
            cell.scoreCell?.text = score
//            cell.scoreCell?.shadowColor = UIColor.black
//            cell.scoreCell?.layer.shadowRadius = 3.0
//            cell.scoreCell?.layer.shadowOpacity = 1.0
//            cell.scoreCell?.layer.shadowOffset = CGSize(width: 4, height: 4)
//            cell.scoreCell?.layer.masksToBounds = false
        
            cell.albumNameCell?.text = current?.albumName
            cell.albumYearCell?.text = current?.albumYear
            cell.albumLabelCell?.text = current?.label
            
            if(currentArtist?.pitchfork[indexPath.row].bestNewMusic == true){
                cell.albumAwardCell?.text = "Best New Music"
                cell.albumAwardCell?.textColor = UIColor.black
            }else{
                cell.albumAwardCell?.text = ""
            }
            cell.scoreCell?.font = UIFont(name: "Avenir", size: 38.0)
            cell.scoreCell?.textColor = UIColor.white
            
            cell.albumNameCell?.font = UIFont(name: "Avenir", size: 17.0)
            cell.albumNameCell?.textColor = UIColor.white
            
            cell.albumYearCell?.font = UIFont(name: "Avenir", size: 17.0)
            cell.albumYearCell?.textColor = UIColor.white
            
            cell.albumLabelCell?.font = UIFont(name: "Avenir", size: 17.0)
            cell.albumLabelCell?.textColor = UIColor.white
            
            cell.albumAwardCell?.font = UIFont(name: "Avenir", size: 17.0)
            cell.albumAwardCell?.textColor = UIColor.white
            
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            let url = URL(string: (currentArtist?.pitchfork[indexPath.row].albumPhoto640X640)!)
            getData(from: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url!.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    cell.albumImage.image = UIImage(data: data)
                    let tintView = UIView()
                    tintView.backgroundColor = UIColor(white: 0, alpha: 0.3) //change to your liking
                    tintView.frame = CGRect(x: 0, y: 0, width: cell.albumImage.frame.width, height: cell.albumImage.frame.height)
                    
                    cell.albumImage.addSubview(tintView)
                }
            }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 180.00
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "", message:
            currentArtist?.pitchfork[indexPath.row].albumDescription, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
//        let albumController = AlbumViewController()
//        albumController.descriptionText = currentArtist?.pitchfork[indexPath.row].albumDescription
//        let url = URL(string: (currentArtist?.pitchfork[indexPath.row].albumPhoto640X640)!)
//        print("Download Started")
//        getData(from: url!) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url!.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                print("**** Artist Controller: image \(data)")
//                let image = UIImage(data: data)
//                print("**** Artist Controller: image\(image)")
//                albumController.imagePassedOver = image
//                //albumController.backgroundImage.image = UIImage(data: data)
//            }
//        }
//
//        self.performSegue(withIdentifier: "fromArtistToAlbum", sender: self)
        
    }
    //STRUCTS
    struct ArtistInfo: Codable {
        let pitchfork: [Pitchfork]
        let spotify: Spotify
        
        enum CodingKeys: String, CodingKey {
            case pitchfork = "Pitchfork"
            case spotify = "Spotify"
        }
    }
    
    struct Pitchfork: Codable {
        let albumDescription, albumName: String
        let albumPhoto640X640: String
        let albumScore: Double
        let albumYear: String
        let bestNewMusic: Bool
        let label: String
        
        enum CodingKeys: String, CodingKey {
            case albumDescription = "Album description"
            case albumName = "Album name"
            case albumPhoto640X640 = "Album photo 640x640"
            case albumScore = "Album score"
            case albumYear = "Album year"
            case bestNewMusic = "Best New Music"
            case label = "Label"
        }
    }
    
    struct Spotify: Codable {
        let albumsSingles: [String]
        let artistName: String
        let artistPhoto600X600: String
        let genres: [String]
        let totalNumberOfSpotifyFollowers: Int
        
        enum CodingKeys: String, CodingKey {
            case albumsSingles = "Albums/Singles"
            case artistName = "Artist Name"
            case artistPhoto600X600 = "Artist Photo 600x600"
            case genres = "Genres"
            case totalNumberOfSpotifyFollowers = "Total Number of Spotify Followers"
        }
    }
}
