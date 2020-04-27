//
//  NewsViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 22/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, RefreshNews {
    
    let model = NewsAPIRequest.shared
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsList:[NewsItem] {
        get { return model.newsList }
        set { model.newsList = newValue }
    }
    
    let categoryArray:[String] = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryArray[row]
        model.getNews(category: categoryArray[row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1006) as! UILabel
        let image = cell.viewWithTag(1007) as! UIImageView
        let contentLabel = cell.viewWithTag(1008) as! UILabel
        let noImageLabel = cell.viewWithTag(1009) as! UILabel
        
        titleLabel.text = newsList[indexPath.row].title
        
        let urlResponse = newsList[indexPath.row].imageURL

        if let imageURLString = urlResponse {
            
            let imageURL = URL(string: imageURLString)!

            let imageData = try! Data(contentsOf: imageURL)

            image.image = UIImage(data: imageData)
            
            noImageLabel.isHidden = true
            
        } else {
            image.backgroundColor = UIColor.gray
        }
        
        if let content = newsList[indexPath.row].content {
            contentLabel.text = content
        } else {
            contentLabel.text = "No description available"
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        model.delegate = self
        
        setUpCategoryPicker()

        // Get general news as default
        model.getNews(category: "general")
    }
    
    func updateUI() {
        newsTableView.reloadData()
    }
    
    func setUpCategoryPicker(){
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(categoryTextFieldPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.inputView = categoryPicker
    }
    
    // Allow picker view to be dismissed
    @objc func categoryTextFieldPicker(){
        categoryTextField.resignFirstResponder()
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? NewsDetailViewController
        guard let selectedRow = self.newsTableView.indexPathForSelectedRow else { return }
        let selectedNewsItem = newsList[selectedRow.row]
        destination?.selectedNewsItem = selectedNewsItem
    }
}
