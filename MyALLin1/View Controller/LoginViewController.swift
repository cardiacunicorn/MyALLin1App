//
//  LoginViewController.swift
//  MyALLin1
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import STTwitter

class LoginViewController: UIViewController {
    
    // MARK: - Buttons
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        
        // MARK: FacebookLogin
        
//            let loginManager = LoginManager()
//            loginManager.logIn(
//                permissions: [.publicProfile, .userFriends],
//                viewController: self
//            ) { result in
//                self.loginManagerDidComplete(result)
//            }
        
    }
    
    // MARK: Logout button
    // FIXME: Now redundant?
    @IBAction func logoutButton(_ sender: Any) {
        // Facebook section
        let loginManager = LoginManager()
        loginManager.logOut()

        let alertController = UIAlertController(
            title: "Logout",
            message: "Logged out.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Functions
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Login view loaded.")
        
        // MARK: STTwitter Instantiation
        // Not sure if this is just going to authorise me, or each user?
        let twitter = STTwitterAPI(oAuthConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G", oauthToken: "2849820361-VDYgYPW59D62Eyt3DtzMGJJdSEr1WLPGKCyoTS2", oauthTokenSecret: "QieOqVMKm7KR8IXAwpcWn9XI7hFDZ7CgcdZTtptQyb1eR")
        
        // MARK: STTwitter Login
        twitter?.verifyCredentials(
            userSuccessBlock: { // What to do if credentials are verified
                (username, userId) -> Void in
                print(username ?? "No username", userId ?? "No user ID")
                
                // MARK: Get Timeline
                twitter?.getHomeTimeline(
                    sinceID: nil,
                    count: 2, // How many statuses will be returned
                    successBlock: { // What to do with retrieved timeline statuses
                        (statuses) -> Void in
                        
                        for status in statuses! {
                            print(status)
                            // TODO: Process status JSON
                        }
                        
                    },
                    errorBlock: {
                        (error) -> Void in
                        print(error as Any)
                    }
                )
                
            },
            errorBlock: {
                (error) -> Void in
                print(error as Any)
            }
        )
        
        // MARK: Facebook login state check
        // This is how you would check that a user is in a logged in state:
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("User is successfully logged in through Facebook.\nAccess token: \(accessToken)")
        }
        
    }
    
    // MARK: Facebook Login Manager function
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(
                title: "Login Cancelled",
                message: "User cancelled login.",
                preferredStyle: .alert
            )

        case .failed(let error):
            alertController = UIAlertController(
                title: "Login Fail",
                message: "Login failed with error \(error)",
                preferredStyle: .alert
            )

        case .success(let grantedPermissions, _, _):
            alertController = UIAlertController(
                title: "Login Success",
                message: "Login succeeded with granted permissions: \(grantedPermissions)",
                preferredStyle: .alert
            )
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

