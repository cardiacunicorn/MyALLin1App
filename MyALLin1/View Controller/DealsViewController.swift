//
//  DealsViewController.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RefreshDeals {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = DealAPIRequest.shared
    
    var dealList:[DealItem] {
        get { return model.dealList}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.getAllDealCategoryItems()
        //model.getCategoryItems(searchTerm: "iphone")
    }
    
    override func viewDidAppear(_ animated: Bool){
        updateUI()
    }
    
    func updateUI() {
        self.collectionView.reloadData()
        print("Updating collection UI")
    }
    
    // Open the URL for the item when selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Need to fix issue with simulator automatically redirecting to HTTPS instead of HTTP. Issue lies with simulator Safari, not the app.
        if let url = URL(string: dealList[indexPath.item].itemUrl){
            UIApplication.shared.open(url)
            print("Opening " + dealList[indexPath.item].itemUrl)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sleep(2)
        print("Total deals in array: " + String(dealList.count))
        return dealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealsCell", for: indexPath) as! DealsCell

        let dealTitle = dealList[indexPath.item].title
        
        cell.title.text = dealTitle
    
        return cell
    }
    
    
}
