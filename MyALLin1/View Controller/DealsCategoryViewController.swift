//
//  DealsCategoryViewController.swift
//  MyALLin1
//
//  Created by Chris Bowe on 18/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class DealsCategoryViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = DealCategoryManager.sharedInstance
    var dealViewController = DealsViewController()
    var currentDealIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    @IBAction func onPlusTapped(){
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Category"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            let name = alert.textFields?.first!.text!
            self.model.addDealCategory(name!)
            self.updateUI()
            self.dealViewController.getAllDealCategoryItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension DealsCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCategoryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as UITableViewCell
        
        //Variables for each element in the current cell
        let name = cell.viewWithTag(1001) as! UILabel
        
        //Get current deal name
        let categoryDetails = model.getCategoryName(index: indexPath.row)
        
        //Set all elements in the current cell to the vendor data
        name.text = categoryDetails
        
        //Return cell to the view
        return cell
    }
    
    //Allow user to delete categories
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteDealCategory(dealCategory: model.getCategory(index: indexPath.row))
            updateUI()
            self.dealViewController.getAllDealCategoryItems()
        }
    }
}
