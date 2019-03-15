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
//ON LOAD
    @IBOutlet weak var boxView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("**** in viewDidLoad")
        setupTitle()
        setupCustomGoogleButtons()
        checkAuth()
        self.view.backgroundColor = UIColor(red:0.77, green:1.00, blue:0.98, alpha:1.00)
        boxView.layer.cornerRadius = boxView.frame.height/50
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
//SETUP TILE
    
    @IBOutlet weak var nameOfApp: UILabel!
    func setupTitle(){
        nameOfApp.layer.shadowColor = UIColor.black.cgColor
        nameOfApp.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nameOfApp.layer.masksToBounds = false
        nameOfApp.layer.shadowRadius = 0.80
        nameOfApp.layer.shadowOpacity = 0.50
    }
//CHECK AUTH
    func checkAuth(){
        print("**** checking if user is already signed in or not")
        if let user = Auth.auth().currentUser { //if there is present the UserViewController
            print("current user:\(user) will begin segue")
            signInSegue()
        } else {
            print("no user") //otherwise do nothingt
        }
    }
//SETUP GOOGLE SIGN IN BUTTON
    @IBOutlet weak var googleSignInButton: UIButton!
    func setupCustomGoogleButtons(){
        print("**** in setup custom google button")
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        googleSignInButton.backgroundColor = UIColor.white
        googleSignInButton.setTitle("Sign in with Google", for: .normal)
        googleSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        googleSignInButton.layer.shadowColor = UIColor.black.cgColor
        googleSignInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        googleSignInButton.layer.masksToBounds = false
        googleSignInButton.layer.shadowRadius = 3.0
        googleSignInButton.layer.shadowOpacity = 0.5
        googleSignInButton.layer.cornerRadius = 10
        print("**** setting GID uiDelegate and delegate")
        
    }
//GOOGLE SIGNIN BUTTON TAPPED
    @IBAction func googleSignInButtonTapped(_ sender: Any) {
        print("**** in google sign in button tappedr, going to use GID.signIn()")
        GIDSignIn.sharedInstance()?.signIn()
    }
    func signInSegue(){
        print("**** in signInSegue, performing segue for user")
        performSegue(withIdentifier: "fromLoginToHome", sender: self)
    }
}
extension ViewController: GIDSignInDelegate {
    // This function gets called after the google sign in was succesful
    // However we still need to sign in with firebase using the credentials from the google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("**** in extension")
        print("**** Signing in...")
        if let error = error {
            print("**** Sign in error\(error)")
            return
        } else{
            //get google idToken and accessToken, and exchange them for firebase credentials
            guard let authentication = user.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            //Use firebase credentials to authenticate
            Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
                if let error = error {
                    print("**** Sign in error\(error)")
                    return
                }
                print("**** Signed in user " + user.profile.name)
                self.signInSegue()
            }
        }
    }
}
