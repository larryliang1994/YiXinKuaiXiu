//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanOrderListTableViewController: OrderListTableViewController {

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
            
            if order.type == .Urgent {
                typeLabel.backgroundColor = Constants.Color.Orange
                typeLabel.text = "紧急"
            } else if order.type == .Pack {
                typeLabel.backgroundColor = Constants.Color.Green
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
            
            let rightButton = cell.viewWithTag(Constants.Tag.CustomerOrderListCellRightButton) as! UIButton
            
            let reminderLabel = cell.viewWithTag(Constants.Tag.CustomerOrderListCellReminder) as! UILabel
            reminderLabel.hidden = true
            
            switch order.state! {
            case .Cancelling:
                leftButton.hidden = false
                leftButton.layer.borderWidth = 1
                leftButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                leftButton.layer.cornerRadius = 3
                leftButton.setTitle("同意", forState: .Normal)
                leftButton.addTarget(self, action: #selector(HandymanOrderListTableViewController.agreeCancelOrderConfirm), forControlEvents: .TouchUpInside)
                
                rightButton.hidden = false
                rightButton.setTitle("不同意", forState: .Normal)
                rightButton.backgroundColor = UIColor.whiteColor()
                rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                rightButton.layer.cornerRadius = 3
                rightButton.layer.borderWidth = 1
                rightButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                rightButton.addTarget(self, action: #selector(HandymanOrderListTableViewController.disagreeCancelOrderConfirm), forControlEvents: .TouchUpInside)
                
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
                background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 36)
            } else {
                if indexPath.row == 1 {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: UIScreen.mainScreen().bounds.width - 20, height: 50)
                } else if indexPath.row == order.payments?.count {
                    background.frame = CGRect(x: origin.minX + 10, y: origin.minY - 20, width: UIScreen.mainScreen().bounds.width - 20, height: 56)
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == (orders[indexPath.section].payments?.count)! + 1 {
            if orders[indexPath.section].state == .Cancelling {
                return UITableViewAutomaticDimension
            } else {
                return 8
            }
        } else {
            if indexPath.row == 1 || indexPath.row == orders[indexPath.section].payments?.count {
                return 36
            } else {
                return 24
            }
        }
    }
    
    func agreeCancelOrderConfirm(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "同意取消订单",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.pleaseWait()
            
            let cell = sender.superview?.superview as! UITableViewCell
            let selectedIndexPath = self.tableView.indexPathForCell(cell)!
            
            OrderModel(orderDelegate: self).cancelOrderConfirm(self.orders[(selectedIndexPath.section)], confirm: true)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func disagreeCancelOrderConfirm(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "不同意取消订单",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.pleaseWait()
            
            let cell = sender.superview?.superview as! UITableViewCell
            let selectedIndexPath = self.tableView.indexPathForCell(cell)!
            
            OrderModel(orderDelegate: self).cancelOrderConfirm(self.orders[(selectedIndexPath.section)], confirm: false)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func onCancelOrderConfirmResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("已发送", autoClear: true, autoClearTime: 2)
            refresh()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let hodvc = destination as? HandymanOrderDetailViewController {
            hodvc.order = segueOrder
        }
        
    }
}
