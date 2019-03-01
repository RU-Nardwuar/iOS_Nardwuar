//
//  ArtistViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/28/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 3
        }else if(section == 1){
            return 2
        }else if(section == 2){
            return 1
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAPI", for: indexPath)
        return cell
    }
    

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var quickInfoHeader: UILabel!
    @IBOutlet weak var quickInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationButtons()
        setupProfilePicAndQuickInfo()
    }
    func setupNavigationButtons(){
        
        let fullName = UILabel()
        fullName.text = "Artist Most Popular Name Here"
        navigationItem.title = fullName.text
    }
    func setupProfilePicAndQuickInfo(){
        profilePic.layer.borderWidth = 3
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        quickInfoHeader.text = "Anne Smith"
        quickInfo.text = "Born February 28, 1990 in Los Angeles, California"
        
        backgroundImage.alpha = 0.85
    }
    
}
