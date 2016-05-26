//
//  OrderGrabTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderGrabTableViewController: UITableViewController, OrderDelegate, GrabOrderDelegate {
    
    var orders: [Order] = []
    
    var segueOrder: Order?
    
    var fromDistance: Int?
    var toDistance: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
        tableView.tableFooterView = footer
        
        refresh()
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        
        OrderModel(orderDelegate: self).pullGrabOrderList("", fromDistance: fromDistance, toDistance: toDistance)
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {
        refreshControl?.endRefreshing()
        if result {
            orders = orderList
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count
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
        
        let order = orders[indexPath.section]

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
        if order.type == .Normal {
            typeLabel.backgroundColor = Constants.Color.Orange
            typeLabel.text = "普通"
            feeLabel.text = "检查费" + " ￥" + String(order.fee!)
        } else if order.type == .Pack {
            typeLabel.backgroundColor = Constants.Color.Green
            typeLabel.text = "打包"
            feeLabel.text = "打包费" + " ￥" + String(order.fee!)
        } else {
            typeLabel.backgroundColor = Constants.Color.Blue
            typeLabel.text = "预约"
            feeImg.hidden = true
            feeLabel.hidden = true
        }
        
        descLabel.text = order.desc
        
        maintenanceTypeLabel.text = order.mType! + "维修"
        
        distanceLabel.text = "距离您\(order.distance!)公里"
        
        timeLabel.text = UtilBox.getDateFromString(order.date!, format: Constants.DateFormat.MDHm)
        
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 2
        button.layer.borderColor = Constants.Color.Primary.CGColor
        button.enabled = false

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueOrder = orders[indexPath.section]
        performSegueWithIdentifier(Constants.SegueID.ShowOrderGrabDetailSegue, sender: self)
    }
    
    func didGrabOrder() {
        refresh()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let ogdvc = destination as? OrderGrabDetailViewController {
            ogdvc.order = segueOrder
            ogdvc.delegate = self
        }
    }
    
    func onPublishOrderResult(result: Bool, info: String) {}
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}
