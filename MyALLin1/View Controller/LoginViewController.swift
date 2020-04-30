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
    private let consumerKey = "0bxAILPpJ4gORixVzWJfahjRV"
    private let consumerSecret = "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G"
    let swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    private var result: [JSON] = []
    
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
    }
    
    func authorise() {
        let landingURL = URL(string: "MyALLin1://success")!
        swifter.authorize(
            withCallback: landingURL,
            presentingFrom: self,
            success: {
                (token, response) in
                if let token = token {
                    print("You are now authorised through Twitter. Token: \(token)")
                }
            },
            failure: {
                (error) in
                print("Error in authorisation process: \(error)")
            }
        )
    }
    
    func getTimeline() {
        swifter.getHomeTimeline(
            count: 10,
            success: {
                (json) in
                self.result = json.array ?? []
                print("First tweet text: \(json[0]["text"].string)")
            },
            failure: { (error) in
                print(error)
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hand the tweets to the next view controller
        // guard let destination = segue.destination as? TimelineViewController else { return }
        // destination.tweets = result
    }
}

