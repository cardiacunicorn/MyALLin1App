//
//  DealsViewController.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController {
    
    var model = DealAPIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        print("Testing eBay API")
        model.getBearerToken()
    }
}
