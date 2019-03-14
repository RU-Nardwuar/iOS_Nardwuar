//
//  ArtistViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/28/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//ON LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        setupProfilePicAndQuickInfo()
    }
//SETUP UI
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var quickInfoHeader: UILabel!
    @IBOutlet weak var quickInfo: UILabel!
    func setupNavigation(){
        let fullName = UILabel()
        fullName.text = "Anne Smith"
        navigationItem.title = fullName.text
    }
    func setupProfilePicAndQuickInfo(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        //profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.shadowColor = UIColor.black.cgColor
        profilePic.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profilePic.layer.shadowRadius = 5.0
        profilePic.layer.shadowOpacity = 0.5
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        quickInfoHeader.text = "Anne Smith"
        quickInfo.text = "Born February 28, 1990 in Los Angeles, California"
        
        backgroundImage.alpha = 0.85
    }
//TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.00
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAPI", for: indexPath)
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.shadowRadius = 3.0
        cell.imageView?.layer.shadowOpacity = 0.5
        if(indexPath.row == 0){
            cell.textLabel?.text = "Spotify API Details"
            cell.imageView?.image = UIImage(named: "icons8-spotify-filled-50-3")
        } else if(indexPath.row == 1){
            cell.textLabel?.text = "Twitter API Details"
            cell.imageView?.image = UIImage(named: "icons8-twitter-50-5")
        } else if(indexPath.row == 2){
            cell.textLabel?.text = "Genius API Details"
            cell.imageView?.image = UIImage(named: "genius-50")
        } else if(indexPath.row == 3){
            cell.textLabel?.text = "Pitchfork API Details"
            cell.imageView?.image = UIImage(named: "icons8-pitchfork-50")
        }
        return cell
    }
}
