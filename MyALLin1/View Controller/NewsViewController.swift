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
    
    // Specify list of categories that can be selected by the user as an array
    let categoryArray:[String] = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    
    // Set components of table view for displaying list of news items
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

        // Check if an image URL string was returned by the API
        if let imageURLString = urlResponse {
            do {
                // Convert image URL to UIImage to allow display
                let imageURL = URL(string: imageURLString)!
                let imageData = try Data(contentsOf: imageURL)
                image.image = UIImage(data: imageData)
                noImageLabel.isHidden = true
            } catch {
                // If the API returned an invalid image URL, display placeholder
                image.backgroundColor = UIColor.gray
                noImageLabel.isHidden = false
            }
        } else {
            // If the API did not return an image URL, display placeholder
            image.backgroundColor = UIColor.gray
            noImageLabel.isHidden = false
        }
        
        // Check if content description was returned by the API
        if let content = newsList[indexPath.row].content {
            contentLabel.text = content
        } else {
            // If the API did not return content description, display placeholder
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
    
    // Initialise picker view for selecting news category
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
    
    // Set components of picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    // Get news based on the category selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryArray[row]
        model.getNews(category: categoryArray[row])
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
