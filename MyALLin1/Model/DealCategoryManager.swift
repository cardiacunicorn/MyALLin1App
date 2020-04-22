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

    // Arrays to deal category
    var dealCategoryResults = [DealCategory]()
    
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
    
    // get single vendor using index
    func getCategory(index: Int) -> DealCategory {
        return getCategoryList()[index]
    }
    
    // get list of vendors
    func getCategoryList() -> [DealCategory]{
        return dealCategoryResults
    }
    
    // get total count of vendors in list
    func getCategoryCount() -> Int {
        return getCategoryList().count
    }
    
    // get specific vendor details
    func getCategoryDetails(index: Int) -> (String){
        
        let category = getCategory(index: index)
        let name = category.name!
    
        return (name)
    }
    
    func addDealCategory (_ name: String) {
        let newDealCategory = NSEntityDescription.insertNewObject(forEntityName: "DealCategory", into: managedContext) as! DealCategory
        
        newDealCategory.name = name
        
        appDelegate.saveContext()
    }
    
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
