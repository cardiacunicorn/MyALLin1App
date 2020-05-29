//
//  DevInfoViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 1/5/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class DevInfoViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var notesTableView: UITableView!
    
    var currentVersion:ReleaseNotes?
    
    // Set components of table view for displaying list of release notes for current version
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentVersion!.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        
        let noteLabel = cell.viewWithTag(1010) as! UILabel
        
        noteLabel.text = currentVersion!.notes[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.dataSource = self
        
        // Specify release notes for current version
        let notes = ["User can sign-in to their Twitter account and view their timeline", "User can view nearby cafes on a map", "User can view weather information for current location and saved locations", "User can view eBay deals for selected search terms", "User can view latest news for selected categories", "User can view development information for latest release", "User can submit queries"]
        
        currentVersion = ReleaseNotes(version: 1.0, notes: notes)
        
        versionLabel.text = "Version: " + String(currentVersion!.version)
    }
}
