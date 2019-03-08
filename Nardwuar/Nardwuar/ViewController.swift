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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomGoogleButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBOutlet weak var googleSignInButton: UIButton!
    func setupCustomGoogleButtons(){
        googleSignInButton.backgroundColor = UIColor.white
        googleSignInButton.setTitle("Sign in with Google", for: .normal)
        googleSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        googleSignInButton.layer.shadowColor = UIColor.black.cgColor
        googleSignInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        googleSignInButton.layer.masksToBounds = false
        googleSignInButton.layer.shadowRadius = 3.0
        googleSignInButton.layer.shadowOpacity = 0.5
        googleSignInButton.layer.cornerRadius = 10
        GIDSignIn.sharedInstance()?.uiDelegate = self
        if let user = Auth.auth().currentUser { //if there is present the UserViewController
            print("current user:\(user)")
            signInSegue()
        } else {
            print("no user") //otherwise do nothingt
        }
    }
    func signInSegue(){
        guard let userVC = storyboard?.instantiateViewController(withIdentifier: "fromLoginToHome") else { return }
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    @IBAction func googleSignInButtonTapped(_ sender: Any) {
        handleCustomGoogleSign()
    }
    @objc func handleCustomGoogleSign(){
        GIDSignIn.sharedInstance()?.signIn()
        performSegue(withIdentifier: "fromLoginToHome", sender: self)
    }
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let authentication = user.authentication {
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//
//            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) -> Void in
//                if error != nil {
//                    print("Problem at signing in with google with error : \(String(describing: error))")
//                } else if error == nil {
//                    print("user successfully signed in through GOOGLE! uid:\(Auth.auth().currentUser!.uid)")
//                    print("signed in")
//                    self.performSegue(withIdentifier: "fromLoginToHome", sender: self)
//                }
//            })
//        }
//    }
    
    
//    func setupStandardGoogleButtons(){
//        //google sign in button
//        let googleButton = GIDSignInButton() //if you want to use google's button
//        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
//        view.addSubview(googleButton)
//
//        GIDSignIn.sharedInstance()?.uiDelegate = self
//    }
}
extension ViewController: GIDSignInDelegate {
    // This function gets called after the google sign in was succesful
    // However we still need to sign in with firebase using the credentials from the google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Signing in...")
        if let error = error {
            print("Sign in error\(error)")
            return
        }
        
        //get google idToken and accessToken, and exchange them for firebase credentials
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        //Use firebase credentials to authenticate
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print("Sign in error\(error)")
                return
            }
            print("Signed in user " + user.profile.name)
            self.signInSegue()
            
        }
    }
}

