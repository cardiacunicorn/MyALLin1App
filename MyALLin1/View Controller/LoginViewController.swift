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

    @IBAction func loginButton(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .userFriends],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
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

