//
//  DealCategoryManager.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DealCategoryManager {
    
    // Reference to the app delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Reference to the managed context
    let managedContext: NSManagedObjectContext

    // Array for deal category
    var dealCategoryResults = [DealCategory]()
    
    // Get all deal categorys and store in array
    func fetchDealCategorys()
    {
        // Get all deal category records
        let dealCategoryRequest: NSFetchRequest<DealCategory> = DealCategory.fetchRequest()
        
        // update array to store deal category results
        do {
            dealCategoryResults = try managedContext.fetch(dealCategoryRequest)
        }
        catch{
            print()
        }
    }
    
    // Get a single deal category using index
    func getCategory(index: Int) -> DealCategory {
        return getCategoryList()[index]
    }
    
    // Get a list of deal categorys
    func getCategoryList() -> [DealCategory]{
        return dealCategoryResults
    }
    
    // Get a total count of deal categorys
    func getCategoryCount() -> Int {
        return getCategoryList().count
    }
    
    // Get a deal category name
    func getCategoryDetails(index: Int) -> (String){
        
        let category = getCategory(index: index)
        let name = category.name!
    
        return (name)
    }
    
    // Add a new deal category
    func addDealCategory (_ name: String) {
        let newDealCategory = NSEntityDescription.insertNewObject(forEntityName: "DealCategory", into: managedContext) as! DealCategory
        
        newDealCategory.name = name
        
        appDelegate.saveContext()
    }
    
    // Delete an existing deal category
    func deleteDealCategory(dealCategory: DealCategory){
        managedContext.delete(dealCategory)
        appDelegate.saveContext()
    }
    
    fileprivate struct Static{
        static var instance: DealCategoryManager?
    }
    
    class var sharedInstance: DealCategoryManager
    {
        if !(Static.instance != nil){
            Static.instance = DealCategoryManager()
        }
        return Static.instance!
    }
    
    init(){
        managedContext = appDelegate.persistentContainer.viewContext
        fetchDealCategorys()
    }
}
