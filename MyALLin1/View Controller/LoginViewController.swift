//
//  LoginViewController.swift
//  MyALLin1
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import Swifter

class LoginViewController: UIViewController {
    let consumerKey = "0bxAILPpJ4gORixVzWJfahjRV"
    let consumerSecret = "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G"
    let swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
    // MARK: - Buttons
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        authorise()
    }
    
    // MARK: Logout button
    @IBAction func logoutButton(_ sender: Any) {
        getTimeline()
    }
    
    // MARK: - Functions
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view loaded.")
        
    }
    
    func authorise() {
        let landingURL = URL(string: "MyALLin1://success")!
        swifter.authorize(
            withCallback: landingURL,
            presentingFrom: self,
            success: {
                (token, response) in
                print("You are now authorised through Twitter")
                print(token)
                
                // TODO: Save token
                
            },
            failure: {
                (error) in
                print("Error in authorisation process")
                print(error)
            }
        )
    }
    
    func getTimeline() {
        swifter.getHomeTimeline(
            count: 10,
            success: {
                (json) in
                print("Response: ")
                print(json)
            },
            failure: { (error) in
                print(error)
            }
        )
    }
}

