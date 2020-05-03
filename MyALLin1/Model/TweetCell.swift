//
//  TweetCell.swift
//  MyALLin1
//
//  Created by Alex Mills on 4/5/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    var likeAction: ((UITableViewCell) -> Void)?
    var commentAction: ((UITableViewCell) -> Void)?
    var retweetAction: ((UITableViewCell) -> Void)?
    var shareAction: ((UITableViewCell) -> Void)?
    
    @IBAction func tappedLike(_ sender: Any) {
        likeAction?(self)
    }
    @IBAction func tappedComment(_ sender: Any) {
        commentAction?(self)
    }
    @IBAction func tappedRetweet(_ sender: Any) {
        retweetAction?(self)
    }
    @IBAction func tappedShare(_ sender: Any) {
        shareAction?(self)
    }
    
}
