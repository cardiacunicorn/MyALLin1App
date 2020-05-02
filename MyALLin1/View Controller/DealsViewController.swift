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
    
    var dealList:[DealItem] {
        get { return rest.dealList}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: (width-20) / 2, height: (width-20) / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        rest.delegate = self
        collectionView.dataSource = self
        getAllDealCategoryItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        print("Total deals in array: " + String(dealList.count))
        return dealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealsCell", for: indexPath) as! DealsCell

        let dealCategory = dealList[indexPath.item].category
        let dealTitle = dealList[indexPath.item].title
        let dealPrice = dealList[indexPath.item].value
        let dealCurrency = dealList[indexPath.item].currency
        let imageURL = dealList[indexPath.item].imageUrl
        
        cell.categoryName.text = dealCategory
        cell.itemDescription.text = dealTitle
        cell.itemPrice.text = "$" + dealPrice + " " + dealCurrency
        
        if let url = URL(string: imageURL) {
            do {
                let data = try Data(contentsOf: url)
                cell.itemImage.image = UIImage(data: data)
            } catch let err {
                print ("Error : \(err.localizedDescription)")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let padding: CGFloat =  50
          let collectionViewSize = collectionView.frame.size.width - padding

          return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
      }
    
    func getAllDealCategoryItems() {
        print("Getting all deal items")
        for deal in model.getCategoryList() {
            let categoryName = deal.name!
            rest.getCategoryItems(searchTerm: categoryName)
        }
    }
}
