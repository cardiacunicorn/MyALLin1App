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
    
    var tweets:[JSON] = []
    var swifter = Swifter(consumerKey: "0bxAILPpJ4gORixVzWJfahjRV", consumerSecret: "zaDny7HAqqirRrFvrQ6SBq0s9eCuYTBAcBRKrMjqR2UmNXEz5G")
    
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
    
    func likeButtonTapped(_ likeButton: UIButton) {
        print("Like button tapped")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath) as! TweetCell
        
        if  let tweetText = cell.viewWithTag(1000) as? UILabel,
            let username = cell.viewWithTag(1001) as? UILabel,
            let likeButton = cell.viewWithTag(1003) as? UIButton,
            let commentButton = cell.viewWithTag(1004) as? UIButton,
            let retweetButton = cell.viewWithTag(1005) as? UIButton,
            let shareButton = cell.viewWithTag(1006) as? UIButton,
            let tweetID = tweets[indexPath.row]["id_str"].string
        {
            
            // MARK: Tweet content
            tweetText.text = tweets[indexPath.row]["text"].string
            username.text = "@\(tweets[indexPath.row]["user"]["screen_name"].string!)"
            
            // MARK: - Buttons
            // MARK: Like Button
            if var likes = tweets[indexPath.row]["favorite_count"].double {
                
                if likes >= 1000 {
                    likeButton.setTitle("\(String(format:"%.1f",likes/1000))K", for: .normal)
                } else {
                    likeButton.setTitle(String(format:"%.0f",likes), for: .normal)
                }
                
                // Detect whether a tweet has already been liked
                if var liked = tweets[indexPath.row]["favorited"].bool {
                    if (liked) {
                        // Fill the heart icon
                        likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(UIColor.red), for: .normal)
                    }
                    
                    // MARK: Like Button: Functionality Closure
                    cell.likeAction = {
                        (cell) in
                        if liked == true {
                            self.swifter.unfavoriteTweet(forID: tweetID)
                            // Empty the heart icon
                            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            liked = false
                            likes -= 1
                            if likes < 1000 {
                                likeButton.setTitle(String(format:"%.0f",likes), for: .normal)
                            }
                        } else if liked == false {
                            self.swifter.favoriteTweet(forID: tweetID)
                            // Fill the heart icon
                            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            liked = true
                            likes += 1
                            if likes < 1001 {
                                likeButton.setTitle(String(format:"%.0f",likes), for: .normal)
                            }
                        }
                    }
                    
                }
            }
            
            // MARK: Comment Button
            cell.commentAction = {
                (cell) in
                print("Pressed comment on Tweet ID: \(String(describing: self.tweets[tableView.indexPath(for: cell)!.row]["id_str"].string))")
            }
            
            // MARK: Retweet Button
            if var retweets = tweets[indexPath.row]["retweet_count"].double {
                
                if retweets >= 1000 {
                    retweetButton.setTitle("\(String(format:"%.1f",retweets/1000))K", for: .normal)
                } else {
                    retweetButton.setTitle(String(format:"%.0f",retweets), for: .normal)
                }
                
                // MARK: Retweet Button: Functionality Closure
                cell.retweetAction = {
                    (cell) in
                    // Auto retweet
                    self.swifter.retweetTweet(forID: tweetID)
                    retweets += 1
                    if retweets < 1001 {
                        retweetButton.setTitle(String(format:"%.0f",retweets), for: .normal)
                    }
                }
            }
            
            // MARK: Share Button
            cell.shareAction = {
                (cell) in
                print("Pressed share on Tweet ID: \(String(describing: self.tweets[tableView.indexPath(for: cell)!.row]["id_str"].string))")
            }
        }
        
        // MARK: Tweeter's Image
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
