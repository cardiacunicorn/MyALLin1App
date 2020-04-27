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
    let consumerKey = "0bxAILPpJ4gORixVzWJfahjRV"
    let consumerSecret = "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G"
    
    let twitterapi = STTwitterAPI(appOnlyWithConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
    var api = STTwitterAPI.init()
    
    let swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
    var username = ""
    var password = ""
    
    // MARK: - Buttons
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        
        getLoginDetails()
        
        verifyTwitterKit()
        verifySTTwitter()
        // verifySwifter()
        
    }
    
    // MARK: Logout button
    @IBAction func logoutButton(_ sender: Any) {
//        swifter.getHomeTimeline(count: 5, success: { (json) in
//            print(json)
//        }) { (error) in
//            print(error)
//        }
    }
    
    // MARK: - Functions
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view loaded.")
        
    }
    
    func getLoginDetails() {
        username = "cardiacunicorn"
        password = ""
    }
    
    func verifyTwitterKit() {
        
    }
    
    func verifySTTwitter() {
        
        api = STTwitterAPI(oAuthConsumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
        api.postTokenRequest(
            { (url, oauthToken) in
                print(url)
                print(oauthToken)
                if let url = url {
                    print(url)
                    UIApplication.shared.open(url)
                }
            },
            authenticateInsteadOfAuthorize: false,
            forceLogin: true,
            screenName: nil,
            oauthCallback: "MyALLin1://twitter_access_tokens/",
            errorBlock: { (error) in
                print(error)
            }
        )
        
        api.verifyCredentials(
            userSuccessBlock: { // What to do if credentials are verified
                (username, userId) -> Void in
                print(username ?? "No username", userId ?? "No user ID")
                self.getTimeline(self.api)

            },
            errorBlock: {
                (error) -> Void in
                print(error as Any)
            }
        )
        
    
        
        api.verifyCredentials(
            userSuccessBlock: { // What to do if credentials are verified
                (username, userId) -> Void in
                print(username ?? "No username", userId ?? "No user ID")
                self.getTimeline(self.api)

            },
            errorBlock: {
                (error) -> Void in
                print(error as Any)
            }
        )
        
        verifyWithUsernamePassword()
        verifyWithKnownOAuth()
    }
    
    func verifySwifter() {
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
    
    func verifyWithUsernamePassword() {
        let twitter = STTwitterOAuth(consumerName: "MyALLin1App", consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G", username: username, password: password)

        twitter?.verifyCredentialsRemotely(
            successBlock: { (token, value) in
                print(token)
                print(value)
        },
            errorBlock: { (e) in
                print(e)
        })
    }
    
    func verifyWithKnownOAuth() {
        if let alexstwitter = STTwitterAPI(oAuthConsumerKey: consumerKey, consumerSecret: consumerSecret, oauthToken: "2849820361-VDYgYPW59D62Eyt3DtzMGJJdSEr1WLPGKCyoTS2", oauthTokenSecret: "QieOqVMKm7KR8IXAwpcWn9XI7hFDZ7CgcdZTtptQyb1eR") {
            
            alexstwitter.verifyCredentials(
                userSuccessBlock: { // What to do if credentials are verified
                    (username, userId) -> Void in
                    print(username ?? "No username", userId ?? "No user ID")
                    self.getTimeline(alexstwitter)

                },
                errorBlock: {
                    (error) -> Void in
                    print(error as Any)
                }
            )
        }
    }
    
    func getTimeline(_ api:STTwitterAPI) {
        self.api.getHomeTimeline(
            sinceID: nil,
            count: 1, // How many statuses will be returned
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
    }
    
}

