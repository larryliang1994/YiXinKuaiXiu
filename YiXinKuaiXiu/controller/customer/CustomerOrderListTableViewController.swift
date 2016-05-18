//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderListTableViewController: OrderListTableViewController, PopBottomViewDataSource, PopBottomViewDelegate, PayDelegate, OrderListChangeDelegate {
    
    var mFee: String?
    
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
                
            case .HasBeenGrabbed:
                if order.type == .Pack {
                    leftButton.hidden = true
                    
                    rightButton.setTitle("去支付", forState: .Normal)
                    rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                } else {
                    leftButton.setTitle("购买配件", forState: .Normal)
                    leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                
                    rightButton.setTitle("付维修费", forState: .Normal)
                    rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goPayAction), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
            case .PaidMFee:
                leftButton.setTitle("补购配件", forState: .Normal)
                leftButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.showPartsMallAction), forControlEvents: UIControlEvents.TouchUpInside)
                
                rightButton.setTitle("去评价", forState: .Normal)
                rightButton.addTarget(self, action: #selector(CustomerOrderListTableViewController.goRatingAction), forControlEvents: UIControlEvents.TouchUpInside)
                
            case .Cancelling:
                leftButton.hidden = true
                rightButton.hidden = true
                reminderLabel.hidden = true
                
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 66
        } else if indexPath.row == (orders[indexPath.section].payments?.count)! + 1 {
            let state = orders[indexPath.section].state
            if state == .PaidFee || state == .HasBeenRated {
                return 8
            } else {
                return 52
            }
        } else {
            return 30
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
        payPopoverView.feeLabel.text = "￥" + String(UTF8String: (order.state == .NotPayFee ? order.fee : mFee)!)!
        
        return payPopoverView
    }
    
    func goPay() {
        let order = orders[(selectedIndexPath?.section)!]
        
        if order.state == .NotPayFee {
            PayModel(payDelegate: self).goPay(order.date!, type: .Fee, fee: order.fee!)
        } else {
            PayModel(payDelegate: self).goPayMFee(order.date!, fee: mFee!)
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
        
        let order = orders[(selectedIndexPath?.section)!]
        
        if order.state == .NotPayFee {
            let v = PopBottomView(frame: self.view.bounds)
            v.dataSource = self
            v.delegate = self
            v.showInView(self.view)
        } else {
            let alert = UIAlertController(
                title: "请输入维修费",
                message: nil,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(
                title: "确认",
                style: .Default)
            { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first! as UITextField
                
                if textField.text != nil {
                    self.mFee = textField.text!
                    
                    let v = PopBottomView(frame: self.view.bounds)
                    v.dataSource = self
                    v.delegate = self
                    v.showInView(self.view)
                }
            }
            )
            
            alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = "维修费"
                textField.keyboardType = UIKeyboardType.DecimalPad
                textField.textAlignment = .Center
            }
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func onGoPayResult(result: Bool, info: String) {
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            refresh()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func onGoPayMFeeResult(result: Bool, info: String) {
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            refresh()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func goRatingAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let ratingVC = UtilBox.getController(Constants.ControllerID.Rating) as! RatingViewController
        ratingVC.order = orders[(selectedIndexPath?.section)!]
        ratingVC.delegate = self
        self.navigationController?.showViewController(ratingVC, sender: self)
    }
    
    func showPartsMallAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedIndexPath = tableView.indexPathForCell(cell)!
        
        let partsMallVC = UtilBox.getController(Constants.ControllerID.PartsMall) as! PartsMallViewController
        partsMallVC.order = orders[(selectedIndexPath?.section)!]
        self.navigationController?.showViewController(partsMallVC, sender: self)
    }
    
    func didChange() {
        refresh()
    }
}

protocol OrderListChangeDelegate {
    func didChange()
}