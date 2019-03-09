//
//  ProfileViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var quickInfoHeader: UILabel!
    @IBOutlet weak var quickInfo: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButtons()
        setupProfilePicAndQuickInfo()
        downloadImage(from: structUserData.globalPhoto!)
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
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
    func setupNavigationButtons(){
        
        let fullName = UILabel()
        fullName.text = structUserData.globalDisplayName
        navigationItem.title = fullName.text
    }
    func setupProfilePicAndQuickInfo(){
        profilePic.layer.borderWidth = 3
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        quickInfoHeader.text = "Following 35 Artists"
        quickInfo.text = "Likes Jazz, Country, and Pop music"
        
        backgroundImage.alpha = 0.85
        

    }

}
