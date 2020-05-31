//
//  NewsDetailViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 25/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {
    
    var selectedNewsItem:NewsItem?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedNewsItem = selectedNewsItem else { return }
        let url = URL(string: selectedNewsItem.url)
        loadWebView(url: url)
    }
    
    // Load URL of selected news item in a web view
    func loadWebView(url: URL?){
        guard let url = url else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
