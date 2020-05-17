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
    private var swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    private var result: [JSON] = []
    private var loggedIn = false
    
    // MARK: - Button(s)
    @IBOutlet var button: UIButton!
    
    // MARK: Login Button
    @IBAction func loginButton(_ sender: Any) {
        // Authorise them if credentials don't already exist
        // If the user is already logged in, assume button has changed state to 'Log Out' and overwrite credentials
        if (!loggedIn) {
            authorise()
        } else {
            swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
            self.button.setTitle("Log in to Twitter", for: .normal)
            self.button.setTitleColor(UIColor.white, for: .normal)
            self.button.backgroundColor = UIColor.systemBlue
            loggedIn = false
        }
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
                print("You are now authorised through Twitter")
                self.loggedIn = true
                self.getTimeline()
            },
            failure: {
                (error) in
                print("Error in authorisation process: \(error)")
            }
        )
    }
    
    func getTimeline() {
        swifter.getHomeTimeline(
            count: 25,
            success: {
                (json) in
                self.button.setTitle("Log out", for: .normal)
                self.button.setTitleColor(UIColor.red, for: .normal)
                self.button.backgroundColor = UIColor.white
                self.result = json.array ?? []
                self.performSegue(withIdentifier: "viewFeed", sender: nil)
            },
            failure: { (error) in
                print(error)
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FeedViewController else { return }
        destination.tweets = result
        destination.swifter = swifter
    }
}

