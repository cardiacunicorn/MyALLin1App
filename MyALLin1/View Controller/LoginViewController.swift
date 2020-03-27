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

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Login view loaded.")
        
        let loginButton = FBLoginButton(permissions: [ .publicProfile, .email ])
        loginButton.center = view.center

        view.addSubview(loginButton)
        
        // This is how you would check that a user is in a logged in state:
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("User is successfully logged in through Facebook.\nAccess token: \(accessToken)")
        }
        
    }

}

