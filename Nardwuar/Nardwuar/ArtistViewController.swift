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
    
}
class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
//ON LOAD
    var artistID = "30DhU7BDmF4PH0JVhu8ZRg"
    override func viewDidLoad() {
        super.viewDidLoad()
        startDispatch()
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
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
            
            artistLabel.text = currentArtist?.spotify.artistName
            artistLabel.textColor = UIColor.white
            artistLabel.font = UIFont(name: "Avenir", size: 20.0)
            
            guard let followers = currentArtist?.spotify.totalNumberOfSpotifyFollowers else {return}
            let followersString = String(followers)
            spotifyLabel.text = "Spotify Followers | \(followersString)"
            spotifyLabel.textColor = UIColor.white
            
            guard let genres = currentArtist?.spotify.genres else {return}
            genreLabel.text = genres[0]
            genreLabel.textColor = UIColor.white
            
            navigationController?.navigationBar.barTintColor = Constants.DefaultUI.primaryColor
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.DefaultUI.textColor]
            
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
        if (section == 0){
            return (currentArtist?.pitchfork.count)!
        } else {
            return (currentArtist?.spotify.albumsSingles.count)!
        }
    }
    
//    @IBOutlet weak var scoreLabel: UILabel!
//    @IBOutlet weak var albumNameLabel: UILabel!
//    @IBOutlet weak var yearLabel: UILabel!
//    @IBOutlet weak var labelLabel: UILabel!
//    @IBOutlet weak var bestNewMusicLabel: UILabel!
   // @IBOutlet weak var albumImage: UIImageView!
//    override func viewDidAppear(_ animated: Bool) {
//        tableView.reloadData()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        tableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("**** IN TABLEVIEW")
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! HeadlineTableViewCell
        if(indexPath.section == 0){//best rated
            //cell.textLabel?.text = currentArtist?.pitchfork[indexPath.row].albumName
            //cell.detailTextLabel?.text = currentArtist?.pitchfork[indexPath.row].albumYear
            let current = currentArtist?.pitchfork[indexPath.row]
            let score:String = String(format:"%.1f", (currentArtist?.pitchfork[indexPath.row].albumScore)!)
            cell.scoreCell?.text = score
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
                    //cell.imageCell.image = UIImage(data: data)
                }
            }
            //cell.imageCell.isHidden = true
        } else{
            cell.scoreCell?.isHidden = true
            cell.albumNameCell?.isHidden = true
            cell.albumYearCell?.isHidden = true
            cell.albumLabelCell?.isHidden = true
            cell.albumAwardCell?.isHidden = true
            cell.staticScoreLabel?.isHidden = true
            //cell.imageCell.isHidden = true
            cell.textLabel?.text = currentArtist?.spotify.albumsSingles[indexPath.row]
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Most Recent Albums"
        } else {
            return "All Albums"
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 80.00
        }
        else{
         return 180.00
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "", message:
            currentArtist?.pitchfork[indexPath.row].albumDescription, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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


















let ArtistJsonDataLocal = """
{
    "Pitchfork": [
        {
            "Album description": "The psychic bond between Kanye West and Kid Cudi yields a spacious and melancholy album about brokenness—thoughts are fragmented, relationships are ended, and societal ties are cut",
            "Album name": "KIDS SEE GHOSTS",
            "Album photo 640x640": "https://i.scdn.co/image/64cc5671890ba19c6c42a533eed08da56d29bdca",
            "Album score": 7.6,
            "Album year": "2018",
            "Best New Music": false,
            "Label": "G.O.O.D. Music / Def Jam"
        },
        {
            "Album description": "Kanye West’s stint in Wyoming created an album born from chaos for chaos’ sake. Though it can be somewhat fascinating, it is undoubtedly a low point in his career",
            "Album name": "ye",
            "Album photo 640x640": "https://i.scdn.co/image/05cf2f8b56e595bcbf50fccb894f5fb6c2427750",
            "Album score": 7.1,
            "Album year": "2018",
            "Best New Music": false,
            "Label": "G.O.O.D. Music / Def Jam"
        },
        {
            "Album description": "Finally, after a protracted and often chaotic roll-out, the new Kanye West album is here. The Life of Pablo is the first Kanye West album that's just an album: No major statements, no reinventions, no zeitgeist wheelie-popping. But a madcap sense of humor animates all his best work, and the new record has a freewheeling energy that is infectious and unique to his discography",
            "Album name": "The Life Of Pablo",
            "Album photo 640x640": "https://i.scdn.co/image/443372cd2c6d4245833fb46ac1c5dabca00c78a9",
            "Album score": 9,
            "Album year": "2016",
            "Best New Music": true,
            "Label": "Def Jam / G.O.O.D. Music"
        }
    ],
    "Spotify": {
        "Albums": [
            "KIDS SEE GHOSTS",
            "ye",
            "The Life Of Pablo",
            "Yeezus",
            "Kanye West Presents Good Music Cruel Summer",
            "My Beautiful Dark Twisted Fantasy",
            "808s & Heartbreak",
            "Graduation (French Limited Version)",
            "Graduation",
            "Graduation (Exclusive Edition)",
            "Graduation (Alternative Business Partners)",
            "Late Orchestration",
            "Late Registration"
        ],
        "Artist Name": "Kanye West",
        "Artist Photo 600x600": "https://i.scdn.co/image/a12d8543e28d71d9f1e7f5f363c1a6c73316f9e6",
        "Genres": [
            "chicago rap",
            "pop rap",
            "rap"
        ],
        "Total Number of Spotify Followers": 9580796
    }
}
""".data(using: .utf8)!

//4.24.19
//class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
////ON LOAD
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupNavigation()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        getArtistData()
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
////SETUP DATA
//    func getArtistData(){
//        let artistID = "5K4W6rqBFWDnAN6FQUkS6x"
//        let networkingClient = NetworkingClient()
//        networkingClient.GETartistData(artistID: artistID)
//        setupProfilePicAndQuickInfo()
//    }
////SETUP UI
//    @IBOutlet weak var profilePic: UIImageView!
//    @IBOutlet weak var spotifyLabel: UILabel!
//    @IBOutlet weak var genreLabel: UILabel!
//    func setupNavigation(){
//        let fullName = UILabel()
//        //fullName.text = "Anne Smith"
//        navigationItem.title = fullName.text
//    }
//    func setupProfilePicAndQuickInfo(){
//        let artist = Artist()
//        artist.makeStructForArtist()
//
//       // print("**** CONSTANTS FOR ARTIST \()")
//        profilePic.layer.borderWidth = 0.25
//        profilePic.layer.masksToBounds = false
//        profilePic.layer.shadowColor = UIColor.black.cgColor
//        profilePic.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        profilePic.layer.shadowRadius = 5.0
//        profilePic.layer.shadowOpacity = 0.5
//        profilePic.layer.cornerRadius = profilePic.frame.height/2
//        profilePic.clipsToBounds = true
//
//        let imgURL = URL(string: Constants.structArtistData.artistPhoto!)
//        downloadImage(from: imgURL!)
//
//        guard let followers = Constants.structArtistData.artistFollowers else {return}
//        let followersString = String(followers)
//        spotifyLabel.text = "Spotify Followers | \(followersString)"
//
//        guard let genres = Constants.structArtistData.artistGenres else {return}
//        genreLabel.text = genres[0]
////        for x in genres {
////            genreLabel.text = genreLabel.text! + " " + x
////        }
//        print("**** testing json: \(String(describing: Constants.structArtistData.artistTopAlbums)) ... \(String(describing: Constants.structArtistData.artistAlbums))")
//
//        for url in Constants.structArtistData.artistTopAlbumsPictures!{
//            let albumURL = URL(string: url)
//        }
//    }
////GET PROFILE PIC
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                self.profilePic.image = UIImage(data: data)
//            }
//        }
//    }
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
////TABLEVIEW
//    @IBOutlet weak var tableView: UITableView!
//    func setupTableView(){
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150.00
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if(section == 0){
//            return "Best Rated Albums"
//        } else {
//            return "All Albums"
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
//        if(indexPath.section == 0){ //top 3 albums section
//
//            cell.imageView?.layer.shadowColor = UIColor.black.cgColor
//            cell.imageView?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//            cell.imageView?.layer.masksToBounds = false
//            cell.imageView?.layer.shadowRadius = 3.0
//            cell.imageView?.layer.shadowOpacity = 0.5
//            cell.textLabel?.text = String(Constants.structArtistData.artistTopAlbums![indexPath.row].albumName)
//            cell.detailTextLabel?.text = String(Constants.structArtistData.artistTopAlbums![indexPath.row].albumYear)
//
//                cell.imageView?.image = UIImage(named: "icons8-spotify-filled-50-3")
//
//        }else{ //albums section
//
//        }
//        return cell
//    }
//}
