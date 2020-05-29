//
//  QueriesViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 2/5/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import MessageUI

class QueriesViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    @IBAction func retryButton(_ sender: Any) {
        composeMail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = ""
        retryButton.setTitle("", for: .normal)
        composeMail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        message.text = ""
        retryButton.setTitle("", for: .normal)
        composeMail()
    }
    
    func composeMail(){
        // Check if user has mail application configured
        // If yes, set mail components and display pop-up
        if MFMailComposeViewController.canSendMail(){
        
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients(["s3655705@student.rmit.edu.au"])
            mail.setSubject("MyALLin1 Query")
            mail.setMessageBody("Enter query here", isHTML: false)
            
            self.present(mail, animated: true, completion: nil)
        } else {
            // If mail application is not configured, display
            // appropriate message to the user
            message.text = "Query submission unavailable"
        }
    }
}

extension QueriesViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Set display for when an error occurs
        if let _ = error {
            message.text = "An error has occurred"
            retryButton.setTitle("Try again?", for: .normal)
            controller.dismiss(animated: true)
        }
        
        // Set display for when email pop-up is dismissed, according
        // to whether a query has been sent, cancelled, saved, etc
        switch result {
        case .cancelled:
            message.text = "Query submission cancelled"
            retryButton.setTitle("Try again?", for: .normal)
        case .failed:
            message.text = "Query submission failed"
            retryButton.setTitle("Try again?", for: .normal)
        case .saved:
            message.text = "Query submission saved"
            retryButton.setTitle("Send another query?", for: .normal)
        case .sent:
            message.text = "Your query has been sent. A member of our team will respond shortly"
            retryButton.setTitle("Send another query?", for: .normal)
        @unknown default:
            message.text = "An unknown error has occurred"
            retryButton.setTitle("Try again?", for: .normal)
        }
        controller.dismiss(animated: true)
    }
}
