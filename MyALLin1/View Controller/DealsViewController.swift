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
    
    var model = DealCategoryManager()
    var rest = DealAPIRequest.shared

    // Stores the deal items to be displayed
    var dealList:[DealItem] {
        get { return rest.dealList}
        set { rest.dealList = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Layout settings of collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: (width-20) / 2, height: (width-20) / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        rest.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getAllDealCategoryItems()
    }
    
    func updateUI() {
        self.collectionView.reloadData()
    }
    
    // Open the URL for the item when selected
    // NOTE: eBay redirect to their mobile sandbox site using https, which returns a broken link for all items unfortunately - unable to workaround this
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: dealList[indexPath.item].itemUrl){
            UIApplication.shared.open(url)
        }
    }
    
    // Set the size of the collection to equal the amount of deals items in the array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealList.count
    }
    
    // Configuration of cell in collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealsCell", for: indexPath) as! DealsCell
        
        // Variables to store deal item information in
        let dealCategory = dealList[indexPath.item].category
        let dealTitle = dealList[indexPath.item].title
        let dealPrice = dealList[indexPath.item].value
        let dealCurrency = dealList[indexPath.item].currency
        let imageURL = dealList[indexPath.item].imageUrl
        
        //Display information from API as text
        cell.categoryName.text = dealCategory.uppercased()
        cell.itemDescription.text = dealTitle
        cell.itemPrice.text = "$" + dealPrice + " " + dealCurrency
        
        //If no image provided from API display ebay logo, else display image URL as image
        if imageURL == "" {
            cell.itemImage.image = UIImage(named: "eBayLogo.jpg")
        }
        else {
            if let url = URL(string: imageURL) {
                do {
                    let data = try Data(contentsOf: url)
                    cell.itemImage.image = UIImage(data: data)
                } catch let err {
                    print ("Error : \(err.localizedDescription)")
                }
            }
        }
        return cell
    }
    
    // Clear all deal items, then get a new list of deal items.
    func getAllDealCategoryItems() {
        dealList = []
        model.fetchDealCategorys()
        for deal in model.getCategoryList() {
            let categoryName = deal.name!
            rest.getCategoryItems(searchTerm: categoryName)
        }
        if model.getCategoryCount() == 0 {
            rest.queueUpdate()
        }
    }
}
