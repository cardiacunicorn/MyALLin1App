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
import TwitterKit
import STTwitter

class LoginViewController: UIViewController, TWTRComposerViewControllerDelegate{
    
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
        
        // MARK: TwitterKit Login
        // NOTE: Currently failing, due to inability to interpret 'twitterauth://' in Simulator's request
        
            if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
                // App must have at least one logged-in user to compose a Tweet
               
                guard let shareImg2 = UIImage.init(named: "uk") else {
                    print("failed init share img")
                    return
                }
                let composer = TWTRComposerViewController.init(initialText: "UK flag picture will be tweeted", image: shareImg2, videoURL: nil)
                composer.delegate = self
                present(composer, animated: true, completion: nil)
            } else {
                // Log in, and then check again
                TWTRTwitter.sharedInstance().logIn { session, error in
                    if session != nil { // Log in succeeded
                        guard let shareImg2 = UIImage.init(named: "usa") else {
                            print("failed init share img")
                            return
                        }
                        let composer = TWTRComposerViewController.init(initialText: "USA flag picture will be tweeted", image: shareImg2, videoURL: nil)
                        composer.delegate = self
                        self.present(composer, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                        self.present(alert, animated: false, completion: nil)
                    }
                }
            }
        
        // MARK: STTwitter Login
        
        
        
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
        let twitter = STTwitterAPI(oAuthConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G", oauthToken: "2849820361-VDYgYPW59D62Eyt3DtzMGJJdSEr1WLPGKCyoTS2", oauthTokenSecret: "QieOqVMKm7KR8IXAwpcWn9XI7hFDZ7CgcdZTtptQyb1eR")
        twitter?.verifyCredentials(
            userSuccessBlock: {
                (username, userId) -> Void in
                print(username, userId)
            },
            errorBlock: {
                (error) -> Void in
                print(error)
            }
        )
        
        // MARK: Facebook login state check
        // This is how you would check that a user is in a logged in state:
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("User is successfully logged in through Facebook.\nAccess token: \(accessToken)")
        }
        
    }
    
    // MARK: Twitter Compose Delegate Functions
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        print("composerDidCancel, composer cancelled tweet")
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        print("composerDidSucceed tweet published")
    }
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        print("composerDidFail, tweet publish failed == \(error.localizedDescription)")
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

