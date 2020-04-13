//
//  LoginViewController.swift
//  MyALLin1
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import STTwitter

class LoginViewController: UIViewController {
    
    // MARK: - Buttons
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        
    }
    
    // MARK: Logout button
    @IBAction func logoutButton(_ sender: Any) {
        
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
        
    }
}

