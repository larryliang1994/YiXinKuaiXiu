//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController, OrderDelegate, LoadMoreTableFooterViewDelegate {
    var orders: [Order] = []
    
    var tableType: Int?
    var segueOrder: Order?
    
    var selectedIndexPath: NSIndexPath?
    
    var loadMoreFooterView: LoadMoreTableFooterView?
    var loadingMore: Bool = false
    var loadingMoreShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        refresh()
    }
    
    func initView() {
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView!)
        }
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        
        if tableType == 0 {
            OrderModel(orderDelegate: self).pullOrderList("", pullType: .OnGoing)
        } else {
            OrderModel(orderDelegate: self).pullOrderList("", pullType: .Done)
        }
    }
    
    func loadMore() {
        loadingMore = true
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {
        if result {
            orders = orderList
            
            loadingMore = false
            loadMoreFooterView?.loadMoreScrollViewDataSourceDidFinishedLoading(tableView)
            
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
    
    // LoadMoreTableFooterViewDelegate
    func loadMoreTableFooterDidTriggerRefresh(view: LoadMoreTableFooterView) {
        loadMore()
    }
    
    func loadMoreTableFooterDataSourceIsLoading(view: LoadMoreTableFooterView) -> Bool {
        return loadingMore
    }
    
    // UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidScroll(scrollView)
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidEndDragging(scrollView)
        }
    }
    
    func onPublishOrderResult(result: Bool, info: String) {}

    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}
