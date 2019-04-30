//
//  AlbumViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 4/27/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    var descriptionText:String?
    @IBOutlet weak var descriptionBox: UITextView!
    var imagePassedOver:UIImage?
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = imagePassedOver
        loadTextbox()
    }
    func loadTextbox(){
        guard let desc = descriptionText else {return}
        descriptionBox.text = desc
    }

}
