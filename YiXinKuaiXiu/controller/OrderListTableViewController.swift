//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController, OrderDelegate {
    var orders: [Order] = []
    
    var tableType: Int?
    var segueOrder: Order?
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        refresh()
    }
    
    func initView() {
        
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        
        if tableType == 0 {
            OrderModel(orderDelegate: self).pullOrderList("", pullType: .OnGoing)
        } else {
            OrderModel(orderDelegate: self).pullOrderList("", pullType: .Done)
        }
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {
        if result {
            orders = orderList
            
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
        
        refreshControl?.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let payment = orders[section].payments {
            return 2 + payment.count
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueOrder = orders[indexPath.section]
        if Config.Role == Constants.Role.Customer {
            performSegueWithIdentifier(Constants.SegueID.ShowCustomerOrderDetail, sender: self)
        } else {
            performSegueWithIdentifier(Constants.SegueID.ShowHandymanOrderDetailSegue, sender: self)
        }
    }
    
    func onPublishOrderResult(result: Bool, info: String) {}

    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}
