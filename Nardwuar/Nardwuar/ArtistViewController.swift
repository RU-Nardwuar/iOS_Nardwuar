//
//  ArtistViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/28/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
   // for artist page
    @IBOutlet weak var scoreCell: UILabel!
    @IBOutlet weak var albumNameCell: UILabel!
    @IBOutlet weak var albumYearCell: UILabel!
    @IBOutlet weak var albumLabelCell: UILabel!
    @IBOutlet weak var albumAwardCell: UILabel!
    @IBOutlet weak var staticScoreLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    //for home page
    @IBOutlet weak var homeViewButton: UIButton!
    @IBOutlet weak var homeArtistLabel: UILabel!
}
class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDownloadDelegate {
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    var currentUserToken = ""
//on load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        loadingText.textColor = Constants.DefaultUI.primaryColor
        setupLoadUI()
        startDispatch()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
        loadingView.isHidden = false
    }
    func setupTableView(){
        blurBackground.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    func pageDoneLoading(){
        self.navigationController?.navigationBar.isHidden = false
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
//get method for artist info
    var artistID = "", currentArtist: ArtistViewController.ArtistInfo?
    func startDispatch(){
        print("**** Artist Controller: in startDispatch function")
        let myGroup = DispatchGroup()
        
        shapeLayer?.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let urlString = "https://nardwuar.herokuapp.com/artist-info/\(artistID)"
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    //Get method: for user route with dynamic percent loader
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let myGroup = DispatchGroup()
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        for _ in 0 ..< 3 {
            
            let urlString = "https://nardwuar.herokuapp.com/artist-info/\(artistID)"
            print("**** Artist Controller: in user route with link ... \(urlString)****")
            guard let url = URL(string: urlString) else { return }
            myGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, _, err) in
                DispatchQueue.main.async {
                    self.percentageLabel?.text = "\(Int(percentage * 100))%"
                    self.shapeLayer?.strokeEnd = percentage
                    if let err = err {
                        print("**** Artist Controller: Failed to get data from url:", err)
                        return
                    }
                    
                    guard let data = data else { return }
                    print("**** Artist Controller: data ...  \(data)")
                    do {
                        let decoder = JSONDecoder()
                        self.currentArtist = try decoder.decode(ArtistInfo.self, from: data)
                        print("**** ARTIST PAGE: CURRENT ARTIST INFO ... \(String(describing: self.currentArtist))")
                        self.tableView.reloadData()
                    } catch let jsonErr {
                        print("**** ARTIST PAGE: Failed to decode:", jsonErr)
                    }
                }
                myGroup.leave()
                }.resume()
        }
        myGroup.notify(queue: .main) {
            print("**** ARTIST PAGE: Finished all requests.")
            self.setupTableView()
            self.setupUI()
            self.setupNavigation()
            self.pageDoneLoading()
        }
        print(percentage)
    }
    //protocol we must always have when download done for user route
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
//follow button
    @IBOutlet weak var followButton: UIButton!
    @IBAction func followButtonTapped(_ sender: UIButton) {
        print("**** ARTIST PAGE: follow button tapped")
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
        animateButton(button: sender)
    }
    func animateButton(button: UIButton){
        print("**** ARTIST PAGE: animating button tapped")
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            button.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.3, animations: {
                                button.transform = CGAffineTransform.identity
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
        followButton.backgroundColor = Constants.DefaultUI.buttonColor
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(Constants.DefaultUI.buttonText, for: .normal)
        isButtonHollow = false
    }
//setup UI
    func setupNavigation(){
        print("**** ARTIST PAGE: in setupNavigation function")
        navigationItem.title = "Artist"
        navigationItem.backBarButtonItem?.title = ""
    }
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var spotifyLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    var isArtistAlreadyFollowed = false
    func setupUI(){
        print("**** ARTIST PAGE: in setupUI function")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
            
            self.percentageLabel?.text = "Welcome"
            self.animateLoad(view: self.loadingView, delay: 1.0)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.DefaultUI.artistBackgroundLightGray, Constants.DefaultUI.artistBackgroundDarkGray]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        gradientView.layer.addSublayer(gradientLayer)
        
        if(isArtistAlreadyFollowed == true){
            fillButton()
        } else{
            hollowButton()
        }
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = Constants.DefaultUI.buttonColor.cgColor
        followButton.layer.masksToBounds = false
        followButton.layer.cornerRadius = followButton.frame.height/2
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
    }
//get route for profile pic
        func downloadImage(from url: URL) {
            print("**** ARTIST PAGE: downloading artist pro pic")
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
//tableview
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionSize = currentArtist?.pitchfork.count else {return 0}
            return sectionSize
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 35))
        headerView.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = "Recent Albums"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 25.0)
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("**** ARTIST PAGE: setting up tableview per row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! HeadlineTableViewCell
        
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
        print("**** ARTIST PAGE: row selected in tableview")
        let alertController = UIAlertController(title: "", message:
            currentArtist?.pitchfork[indexPath.row].albumDescription, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
//struct for artist info
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
