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
    

    func saveDealCategory(_ name: String)
    {
        // get the deal category entity from core data
        let dealCategory = NSEntityDescription.insertNewObject(forEntityName: "DealCategory", into: managedContext) as! DealCategory
        
        // set the deal category attributes to be the variables provided to the function
        dealCategory.name = name
        
        // save changes
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
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
        fetchDealCategorys()
    }
}
