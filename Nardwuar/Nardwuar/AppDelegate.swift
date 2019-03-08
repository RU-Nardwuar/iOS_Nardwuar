//
//  AppDelegate.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 2/26/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //        var emailGlobal = ""
    //        var displayNameGlobal = ""
    //        var uidGlobal = ""
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        if let error = error{//failed to login to google
    //            print(error.localizedDescription)
    //            return
    //        } else{//success to login to google
    //            guard let authentication = user.authentication else {return}
    //            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    //            Auth.auth().signInAndRetrieveData(with: credential){ (result, error) in
    //                if error == nil{//success to make a firebase user with google account
    //                    //call function to grab id token only used for backend
    //                    let currentUser = Auth.auth().currentUser
    //                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
    //                        if let error = error {
    //                            print("**** could not retrieve ID TOKEN\(error)")
    //                            return;
    //                        }
    //                        print("***** ID TOKEN\(String(describing: idToken))")
    //                        // Send token to your backend via HTTPS
    //                        // User is now signed in
    //
    //                        //data approach 1
    //                        guard let email = result?.user.email else {return}
    //                        guard let displayName = result?.user.displayName else {return}
    //                        guard let uid = result?.user.uid else {return}
    //                        print("**** Data for Global Approach 1")
    //                        self.emailGlobal = email
    //                        print(self.emailGlobal)
    //                        self.displayNameGlobal = displayName
    //                        print(self.displayNameGlobal)
    //                        self.uidGlobal = uid
    //                        print("Unique User ID: \(self.uidGlobal)")
    //
    //                        //data approach 2
    //                        print("**** Data for Global Approach 1")
    //                        guard let homeViewController = UIApplication.shared.delegate as? HomeViewController else {return}
    //                        guard let userId = user.userID else {return}                  // For client-side use only!
    //                        guard let idToken = user.authentication.idToken else {return}// Safe to send to the server
    //                        guard let fullName = user.profile.name else {return}
    //                        homeViewController.displayName = displayName
    //                        print("The home controller: \(homeViewController.displayName)")
    //                        guard let givenName = user.profile.givenName else {return}
    //                        guard let familyName = user.profile.familyName else {return}
    //                        guard let emailAddress = user.profile.email else {return}
    //                    }
    //                }else{//failed to make a firebase user with google account
    //                    guard let errorDescription = error?.localizedDescription else {return}
    //                    print(errorDescription)
    //                }
    //            }
    //        }
    //    }
    //
    //
    //
    //    @available(iOS 9.0, *)
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        return GIDSignIn.sharedInstance().handle(url,
    //                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //                                                 annotation: [:])
    //    }
    //    //so app can run with iOS 8 and older
    //    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //        return GIDSignIn.sharedInstance().handle(url,
    //                                                 sourceApplication: sourceApplication,
    //                                                 annotation: annotation)
    //    }
}

