//
//  ShoppingCartPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPopoverView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var parts: [Part] = []
    
    var delegate: PartsMallDelegate?
    
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
    
    @IBAction func clear(sender: UIButton) {
        delegate?.didClear()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartPopoverViewCell") as? ShoppingCartPopoverViewCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("ShoppingCartPopoverViewCell", owner: self, options: nil)[0] as? ShoppingCartPopoverViewCell
        }
        
        cell?.part = parts[indexPath.row]
        cell?.initView()
        cell?.delegate = delegate
        
        return cell!
    }
}
