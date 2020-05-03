//
//  FeedViewController.swift
//  MyALLin1
//
//  Created by Alex Mills on 30/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import Swifter
import SafariServices

class FeedViewController: UITableViewController {
    
    var tweets : [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(tweets[0])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweetText = cell.viewWithTag(1000) as! UILabel
        tweetText.text = tweets[indexPath.row]["text"].string
        let username = cell.viewWithTag(1001) as! UILabel
        username.text = "@\(tweets[indexPath.row]["user"]["screen_name"].string!)"
        let likeButton = cell.viewWithTag(1003) as! UIButton
        if let likes = tweets[indexPath.row]["favorite_count"].double {
            if likes >= 1000 {
                likeButton.setTitle("\(String(format:"%.1f",likes/1000))K", for: .normal)
            } else {
                likeButton.setTitle(String(format:"%.0f",likes), for: .normal)
            }
        }
        // TODO: Not in use / sharing anything
        let commentButton = cell.viewWithTag(1004) as! UIButton
        // Comment count not in JSON
//        commentButton.setTitle(tweets[indexPath.row]["favorite_count"].string, for: .normal)
        let retweetButton = cell.viewWithTag(1005) as! UIButton
        if let retweets = tweets[indexPath.row]["retweet_count"].double {
            if retweets >= 1000 {
                retweetButton.setTitle("\(String(format:"%.1f",retweets/1000))K", for: .normal)
            } else {
                retweetButton.setTitle(String(format:"%.0f",retweets), for: .normal)
            }
        }
        // TODO: Not in use / sharing anything
        let shareButton = cell.viewWithTag(1006) as! UIButton
        
        // Detect whether a tweet has already been liked
        if let liked = tweets[indexPath.row]["favorited"].bool {
            print(liked) // assuming it'd have to be true here, or does it need another if statement?
            if (liked) {
                // Fill the heart icon
            }
        }
        
        let profilepic = cell.viewWithTag(1002) as! UIImageView
        // Convert the profile pic URL into an actual image
        let imageUrlString = tweets[indexPath.row]["user"]["profile_image_url"].string!
        let imageUrl = URL(string: imageUrlString)!
        let imageData = try! Data(contentsOf: imageUrl)
        profilepic.image = UIImage(data: imageData)
        // Apply a circular mask to profile image
        profilepic.layer.cornerRadius = profilepic.frame.size.width/2
        profilepic.clipsToBounds = true
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let username = tweets[indexPath.row]["user"]["screen_name"].string!
        let tweetID = tweets[indexPath.row]["id_str"].string!
        let url = URL(string: "https://twitter.com/\(username)/status/\(tweetID)")!
        let safariView = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
