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
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.00
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAPI", for: indexPath)
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
extension UIImage {
    
    func resize(maxWidthHeight : Double)-> UIImage? {
        
        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0
        
        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }
        
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
}
