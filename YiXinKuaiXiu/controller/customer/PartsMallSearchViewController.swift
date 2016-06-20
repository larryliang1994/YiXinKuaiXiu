//
//  PartsMallSearchViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PartsMallSearchViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var delegate: PartsMallSearchDelegate?
    
    var filteredTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.tintColor = Constants.Color.Primary
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let name = cell?.textLabel?.text!
        let id = UtilBox.findPartIDByName(name!)!
        
        delegate?.didSelect(id)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredTypes.count
        } else {
            return Config.Parts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("partsMallSearchCell")! as UITableViewCell
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel!.text = filteredTypes[indexPath.row]
        } else {
            cell.textLabel!.text = Config.PartNames[indexPath.row]
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredTypes = Config.PartNames.filter({( string : String) -> Bool in
            return string.rangeOfString(searchText) != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController,
                                 shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
}

protocol PartsMallSearchDelegate {
    func didSelect(id: Int)
}
