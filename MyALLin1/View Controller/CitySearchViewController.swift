//
//  CitySearchViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 8/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

class CitySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshResults {
    
    var model = CityAPIRequest.shared
    var savedLocationManager = SavedLocationManager()
    var weatherViewController = WeatherViewController()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var resultsList:[City] {
        get { return model.searchResults }
        set { model.searchResults = newValue }
    }
    
    var isSearchBarEmpty:Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.searchResultsTableView.tableHeaderView = searchController.searchBar
    }
    
    // Set components of table view for displaying list of search suggestions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarEmpty {
            return 0
        } else { return resultsList.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        let searchResultLabel = cell.viewWithTag(1000) as! UILabel
        
        searchResultLabel.text = resultsList[indexPath.row].name + ", " + resultsList[indexPath.row].country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Add selected location to database
        savedLocationManager.addSavedLocation(location: resultsList[indexPath.row])
        // Dismiss view after selection, call for previous view to be reloaded
        searchController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: {
            self.weatherViewController.loadContent() })
    }
    
    func updateUI() {
        searchResultsTableView.reloadData()
    }
    
    // Get list of suggested locations based on user input in search bar
    func filterContentForSearchText(_ searchText: String){
        model.getCities(searchTerm: searchText)
    }
}

extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        // Cancel call(s) to the API that are still in-progress from previous user input
        if let task = model.task {
            if task.state == URLSessionTask.State.running {
                task.cancel()
            }
        }
        let searchBar = searchController.searchBar
        
        filterContentForSearchText(searchBar.text!)
    }
}
