//
//  PartDetailPopover.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/23.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PartDetailPopover: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var parts: [Part] = []

    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return parts[indexPath.row].num == 0 ? 0 : 46
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PartDetailPopoverCell") as? PartDetailPopoverCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("PartDetailPopoverCell", owner: self, options: nil)[0] as? PartDetailPopoverCell
        }
        
        cell?.part = parts[indexPath.row]
        cell?.initView()
        
        return cell!
    }
}
