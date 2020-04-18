//
//  LoginViewController.swift
//  MyALLin1
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import STTwitter
import Swifter

class LoginViewController: UIViewController {
    
    let swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
    let twitter = STTwitterAPI(oAuthConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
    let alexstwitter = STTwitterAPI(oAuthConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G", oauthToken: "2849820361-VDYgYPW59D62Eyt3DtzMGJJdSEr1WLPGKCyoTS2", oauthTokenSecret: "QieOqVMKm7KR8IXAwpcWn9XI7hFDZ7CgcdZTtptQyb1eR")
    
    // MARK: - Buttons
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        
        // MARK: Swifter Login
        if let landingURL = URL(string: "MyALLin1://") {
            swifter.authorize(
                withCallback: landingURL,
                presentingFrom: self,
                success: {
                    (token, response) in
                    // NOTE: The below will not print (and any other code will not run) as iOS 13 won't allow the code to run in the background without proper permissions
                    print("You are now authorised through Twitter")
                },
                failure: {
                    (error) in
                    print("Error in authorisation process")
                }
            )
        }
    }
    
    // MARK: Logout button
    @IBAction func logoutButton(_ sender: Any) {
        swifter.getHomeTimeline(count: 5, success: { (json) in
            print(json)
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: - Functions
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view loaded.")

        // MARK: STTwitter Login
//        alexstwitter?.verifyCredentials(
//            userSuccessBlock: { // What to do if credentials are verified
//                (username, userId) -> Void in
//                print(username ?? "No username", userId ?? "No user ID")
//
//                // MARK: Get Timeline
//                alexstwitter?.getHomeTimeline(
//                    sinceID: nil,
//                    count: 1, // How many statuses will be returned
//                    successBlock: { // What to do with retrieved timeline statuses
//                        (statuses) -> Void in
//
//                        for status in statuses! {
//                            print(status)
//                            // TODO: Process status JSON
//                        }
//
//                    },
//                    errorBlock: {
//                        (error) -> Void in
//                        print(error as Any)
//                    }
//                )
//
//            },
//            errorBlock: {
//                (error) -> Void in
//                print(error as Any)
//            }
//        )
        
    }
}

