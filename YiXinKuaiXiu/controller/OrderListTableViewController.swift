//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import XLRefreshSwift

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
//        tableView.xlfooter = XLRefreshFooter(action: {
//            if self.tableType == 0 {
//                OrderModel(orderDelegate: self).pullOrderList(self.orders.count - 1, pullType: .OnGoing)
//            } else {
//                OrderModel(orderDelegate: self).pullOrderList(self.orders.count - 1, pullType: .Done)
//            }
//            
//            print("more")
//        })
    }
    
    func refresh() {
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
        self.tableView.endFooterRefresh()
        
        if result {
            if info == "0" {
                orders = orderList
            } else {
                orders += orderList
            }
            
            if orders.count == 0 {
                self.tableView.backgroundView = UtilBox.getEmptyView("还没有新订单")
            } else {
                self.tableView.backgroundView = nil
            }
            
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
