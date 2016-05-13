//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderListTableViewController: UITableViewController, OrderDelegate, PopBottomViewDataSource, PopBottomViewDelegate, PayDelegate {
    
    var orders: [Order] = []
    
    var tableType: Int?
    var segueOrder: Order?

    var selectedIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == (orders[indexPath.section].payments?.count)! + 1 {
            return 52
        } else {
            return 30
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueOrder = orders[indexPath.section]
        performSegueWithIdentifier(Constants.SegueID.ShowCustomerOrderDetail, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let codvc = destination as? CustomerOrderDetailViewController {
            codvc.order = segueOrder
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let order = orders[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListTopCell", forIndexPath: indexPath)
            
            let typeLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellType) as! UILabel
            let mainTypeLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellMaintenanceType) as! UILabel
            let statusLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellStatus) as! UILabel
            let descLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellDesc) as! UILabel
            
            typeLabel.clipsToBounds = true
            typeLabel.layer.cornerRadius = 3
            
            if order.type == .Normal {
                typeLabel.backgroundColor = Constants.Color.Orange
                typeLabel.text = "普通"
            } else if order.type == .Pack {
                typeLabel.backgroundColor = Constants.Color.Primary
                typeLabel.text = "打包"
            } else {
                typeLabel.backgroundColor = Constants.Color.Blue
                typeLabel.text = "预约"
            }
            
            mainTypeLabel.text = order.mType! + "维修"
            
            statusLabel.text = Constants.Status[(order.status?.rawValue)!]
            
            descLabel.text = order.desc
            return cell
        } else if indexPath.row == (order.payments?.count)! + 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListBottomCell", forIndexPath: indexPath)
            
            let leftButton = cell.viewWithTag(Constants.Tag.CustomerOrderListCellLeftButton) as! UIButton
            leftButton.layer.borderWidth = 0.5
            leftButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            leftButton.layer.cornerRadius = 3
            leftButton.hidden = false
            
            let rightButton = cell.viewWithTag(Constants.Tag.CustomerOrderListCellRightButton) as! UIButton
            rightButton.hidden = false
            rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightButton.backgroundColor = Constants.Color.Primary
            rightButton.layer.cornerRadius = 3
            rightButton.layer.borderWidth = 0
            
            
            let reminderLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellReminder) as! UILabel
            reminderLabel.hidden = true
            
            switch order.state! {
            case .NotPayFee:
                leftButton.hidden = true
                
                rightButton.setTitle("去支付", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                
            case .PaidFee:
                leftButton.hidden = true
                rightButton.hidden = true
                
            case .PaidPartFee: fallthrough
            case .PaidAll: fallthrough
            case .HasBeenGrabbed:
                leftButton.setTitle("购买配件", forState: .Normal)
                leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                
                rightButton.setTitle("付维修费", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                
            case .PaidMFee:
                leftButton.setTitle("补购配件", forState: .Normal)
                leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                
                rightButton.setTitle("去评价", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goRatingAction), forControlEvents: UIControlEvents.TouchUpInside)
                
            case .Cancelling:
                leftButton.setTitle("同意", forState: .Normal)
                
                rightButton.setTitle("不同意", forState: .Normal)
                rightButton.backgroundColor = UIColor.whiteColor()
                rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                rightButton.layer.borderWidth = 0.5
                rightButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                
                reminderLabel.hidden = false
                
            default:
                leftButton.hidden = true
                rightButton.hidden = true
            }
            
            return cell
        } else {
            let payment = order.payments![indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("customerOrderListMidCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = payment.name
            cell.detailTextLabel?.text = "¥" + String(payment.price!) + (payment.paid ? "(已支付)" : "(未支付)")
            
            let background = UIView()
            background.layer.cornerRadius = 3
            background.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            let origin = cell.contentView.frame
            
            if order.payments?.count == 1 {
                background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 30)
            } else {
                if indexPath.row == 1 {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 40)
                } else if indexPath.row == order.payments?.count {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY - 10, width: UIScreen.mainScreen().bounds.width - 20, height: 40)
                } else {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 30)
                    background.layer.cornerRadius = 0
                }
            }
            
            if cell.subviews.count >= 3 {
                cell.subviews[0].removeFromSuperview()
            }
            
            cell.insertSubview(background, atIndex: 0)
            
            return cell
        }
    }
    
    func hide(){
        for v in self.view.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        let payPopoverView = UIView.loadFromNibNamed("PayPopoverView") as! PayPopoverView
        payPopoverView.closeButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPay), forControlEvents: UIControlEvents.TouchUpInside)
        
        let order = orders[(selectedIndexPath?.section)!]
        payPopoverView.feeLabel.text = "￥" + String(UTF8String: (order.state == .NotPayFee ? order.fee : order.mFee)!)!
        
        return payPopoverView
    }
    
    func goPay() {
        let order = orders[(selectedIndexPath?.section)!]
        
        if order.state == .NotPayFee {
            PayModel(payDelegate: self).goPay(order.date!, type: .Fee, fee: order.fee!)
        } else {
            PayModel(payDelegate: self).goPay(order.date!, type: .MFee, fee: order.mFee!)
        }
    }
    
    func viewHeight() -> CGFloat {
        return 295
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func viewWillDisappear() {
        
    }
    
    func goPayAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let v = PopBottomView(frame: self.view.bounds)
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
    }
    
    func onGoPayResult(result: Bool, info: String) {
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            refresh()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func showPartsMallAction(sender: UIButton) {
        performSegueWithIdentifier(Constants.SegueID.ShowPartsMallSegue, sender: self)
    }
    
    func goRatingAction(sender: UIButton) {
        performSegueWithIdentifier(Constants.SegueID.ShowCustomerRatingSegue, sender: self)
    }
    
    func onPublishOrderResult(result: Bool, info: String) {
    }
}