//
//  ViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//


//3.7.19: sign in button leads to connection with server
import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupStandardGoogleButtons()
        setupCustomGoogleButtons()
    }

    @IBOutlet weak var googleSignInButton: UIButton!
    func setupCustomGoogleButtons(){
//        googleSignInButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        googleSignInButton.backgroundColor = UIColor.white
        googleSignInButton.setTitle("Sign in with Google", for: .normal)
        googleSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        googleSignInButton.layer.shadowColor = UIColor.black.cgColor
        googleSignInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        googleSignInButton.layer.masksToBounds = false
        googleSignInButton.layer.shadowRadius = 3.0
        googleSignInButton.layer.shadowOpacity = 0.5
        googleSignInButton.layer.cornerRadius = 10
        
//        googleSignInButton.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside) //used to give the button an action when tapped
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    @IBAction func googleSignInButtonTapped(_ sender: Any) {
        handleCustomGoogleSign()
        performSegue(withIdentifier: "fromLoginToHome", sender: self)
    }
    func setupStandardGoogleButtons(){
        //google sign in button
        let googleButton = GIDSignInButton() //if you want to use google's button
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    @objc func handleCustomGoogleSign(){
        GIDSignIn.sharedInstance()?.signIn()
    }
}

