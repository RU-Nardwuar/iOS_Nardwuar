//
//  ProfileViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData(token: Constants.structUserData.globalIdToken!)
        downloadImage(from: Constants.structUserData.globalPhoto!)
        setupProfilePicAndQuickInfo()
        setupNavigationBar()
        setupTableView()
    }
//GET USER DATA
    private let networkingClient = NetworkingClient()
    func getUserData(token:String){
        //constants should all be set now, you can then use user data for any page!
        print("**** ProfileView, updated user info to put into UI: ")
        print(Constants.structUserData.globalIdToken as Any)
        print(Constants.structUserData.globalName as Any)
        print(Constants.structUserData.globalUsername as Any)
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
//SETUP PICTURE STYLE AND QUICK INFO
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var quickInfoHeader: UILabel!
    @IBOutlet weak var quickInfo: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    func setupProfilePicAndQuickInfo(){
        profilePic.layer.borderWidth = 0.5
        profilePic.layer.masksToBounds = false
        profilePic.layer.shadowColor = UIColor.black.cgColor
        profilePic.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profilePic.layer.shadowRadius = 5.0
        profilePic.layer.shadowOpacity = 0.5
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        quickInfoHeader.text = "Following 35 Artists"
        quickInfo.text = "Likes Jazz, Country, and Pop music"
        backgroundImage.alpha = 0.85
    }
//SETUP NAV BAR
    func setupNavigationBar(){
        let fullName = UILabel()
        fullName.text = Constants.structUserData.globalUsername
        navigationItem.title = fullName.text
    }
//TABLIEVIEW
    @IBOutlet weak var tableView: UITableView!
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = Constants.DefaultUI.primaryColor
        tableView.backgroundColor = Constants.DefaultUI.primaryColor
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.00
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
        cell.backgroundColor = Constants.DefaultUI.primaryColor
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.shadowRadius = 3.0
        cell.imageView?.layer.shadowOpacity = 0.5
        cell.imageView?.layer.cornerRadius = ((cell.imageView?.layer.frame.height)!)/2
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.textColor = Constants.DefaultUI.textColor
        if(indexPath.row == 0){
            cell.textLabel?.text = "Drake"
            cell.imageView?.image = UIImage(named: "drakejpg")
        } else if(indexPath.row == 1){
            cell.textLabel?.text = "Ed Sheeran"
            cell.imageView?.image = UIImage(named: "edSheeranjpg")
        } else if(indexPath.row == 2){
            cell.textLabel?.text = "Sabrina Claudio"
            cell.imageView?.image = UIImage(named: "sabrinaClaudio100")
        } else if(indexPath.row == 3){
            cell.textLabel?.text = "Hozier"
            cell.imageView?.image = UIImage(named: "hozierjpg")
        }
        return cell
    }
}
