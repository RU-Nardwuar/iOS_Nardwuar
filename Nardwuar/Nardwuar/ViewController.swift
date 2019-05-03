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
//Load page
    override func viewDidLoad() {
        print("**** View Controller: in load, going to setupUI() and checkAuth()")
        super.viewDidLoad()
        setupUI()
        checkAuth()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("**** View Controller: in viewWillAppear, hide navbar")
        self.navigationController?.navigationBar.isHidden = true
    }
//Action: Google button tapped
    @IBAction func googleSignInButtonTapped(_ sender: UIButton) {
        print("**** View Controller: google signin button tapped, going to attempt signin")
        GIDSignIn.sharedInstance()?.signIn()
        
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.3, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
//Check Auth
    func checkAuth(){
        print("**** View Controller: checkAuth(), checking if user is already signed in or not")
        if let user = Auth.auth().currentUser {
            print("**** View Controller: current user:\(user) will now segue to home page")
            performSegue(withIdentifier: "fromLoginToHome", sender: self)
        } else {
            print("**** View Controller: no current user")
        }
    }
//Setup UI
    @IBOutlet weak var nameOfApp: UILabel!
    @IBOutlet weak var googleSignInButton: UIButton!
    func setupUI(){
        print("**** View Controller: setting up UI")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        nameOfApp.layer.shadowColor = Constants.DefaultUI.buttonColor.cgColor
        nameOfApp.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nameOfApp.layer.masksToBounds = false
        nameOfApp.layer.shadowRadius = 0.80
        nameOfApp.layer.shadowOpacity = 0.50
        
        nameOfApp.textColor = Constants.DefaultUI.textColor
        
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
    }
}

//Google Sign In
extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("**** View Controller: GIDSignInDelegate extension, attempting to sign in via Google")
        if let error = error {
            print("**** View Controller: Google Sign in ERROR, error: \(error)")
            return
        } else{
            //get google idToken and accessToken, and exchange them for firebase credentials
            guard let authentication = user.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            //Use firebase credentials to authenticate
            Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
                if let error = error {
                    print("**** View Controller: Google Sign in with credentials ERROR, error: \(error)")
                    return
                }
                print("**** View Controller: Google Sign in with credentials SUCCESS, user: " + user.profile.name)
                self.performSegue(withIdentifier: "fromLoginToHome", sender: self)
            }
        }
    }
    
}
