//
//  OrderGrabTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderGrabTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
        tableView.tableFooterView = footer
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderGrabCell", forIndexPath: indexPath)

        let typeLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellType) as! UILabel
        let descLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellDesc) as! UILabel
        let maintenanceTypeLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellMaintenanceType) as! UILabel
        let feeLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellFee) as! UILabel
        let feeImg = cell.viewWithTag(Constants.Tag.OrderGrabCellFeeImg) as! UIImageView
        let distanceLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellDistance) as! UILabel
        let timeLabel = cell.viewWithTag(Constants.Tag.OrderGrabCellTime) as! UILabel
        let button = cell.viewWithTag(Constants.Tag.OrderGrabCellButton) as! UIButton
        
        typeLabel.clipsToBounds = true
        typeLabel.layer.cornerRadius = 3
        typeLabel.backgroundColor = Constants.Color.Orange
        
        descLabel.text = "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了"
        
        maintenanceTypeLabel.text = "水维修"
        
        feeLabel.text = "检查费 ¥20"
        
        distanceLabel.text = "距离您3公里"
        
        timeLabel.text = "3月29日 18:30"
        
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 2
        button.layer.borderColor = Constants.Color.Primary.CGColor

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.SegueID.ShowOrderGrabDetailSegue, sender: self)
    }
}
