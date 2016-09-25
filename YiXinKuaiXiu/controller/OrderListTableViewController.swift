//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftyTimer

class OrderListTableViewController: UITableViewController, OrderDelegate {
    var orders: [Order] = []
    
    var tableType: Int?
    var segueOrder: Order?
    
    var selectedIndexPath: NSIndexPath?
    
    var isFromHomePage = true
    
    var timer: NSTimer?
    var isRefreshing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
        self.refresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer.new(every: Constants.RefreshTimer.seconds) { (timer: NSTimer) in
            if !self.isRefreshing {
                self.isRefreshing = true
                
                if self.tableType == 0 {
                    OrderModel(orderDelegate: self).pullOrderList(0, pullType: .OnGoing)
                } else {
                    OrderModel(orderDelegate: self).pullOrderList(0, pullType: .Done)
                }
            }
        }
        
        timer?.start()
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
        
        super.viewDidDisappear(animated)
    }
    
    func initView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func refresh() {
        isRefreshing = true
        
        refreshControl?.beginRefreshing()
        
        if tableType == 0 {
            OrderModel(orderDelegate: self).pullOrderList(0, pullType: .OnGoing)
        } else {
            OrderModel(orderDelegate: self).pullOrderList(0, pullType: .Done)
        }
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {
        
        if result {
            tableView.reloadData()
            
            if info == "0" {
                orders = orderList
            } else {
                orders += orderList
            }
            
            if orders.count == 0 {
                self.tableView.backgroundView = UtilBox.getEmptyView("还没有新订单")
            } else {
                self.tableView.backgroundView = nil
                if !isFromHomePage {
                    isFromHomePage = true
                    segueOrder = orders[0]
                    if Config.Role == Constants.Role.Customer {
                        performSegueWithIdentifier(Constants.SegueID.ShowCustomerOrderDetail, sender: self)
                    } else {
                        performSegueWithIdentifier(Constants.SegueID.ShowHandymanOrderDetailSegue, sender: self)
                    }
                }
            }
            
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }

        self.refreshControl?.endRefreshing()
        isRefreshing = false
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
