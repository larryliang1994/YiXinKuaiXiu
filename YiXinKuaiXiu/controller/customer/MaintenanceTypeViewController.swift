//
//  MaintenanceTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class MaintenanceTypeViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    let types = ["门窗修理", "空调、冰箱修理", "彩电修理", "电路修理"]
    
    var filteredTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        searchBar.tintColor = Constants.Color.Primary
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredTypes.count
        } else {
            return self.types.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("maintenanceTypeCell")! as UITableViewCell
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel!.text = filteredTypes[indexPath.row]
        } else {
            cell.textLabel!.text = types[indexPath.row]
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredTypes = self.types.filter({( string : String) -> Bool in
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
