//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanOrderListTableViewController: UITableViewController {

    let orders = [
        Order(type: .Normal, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .ToBeBilled, ratingStar: nil, ratingDesc: nil, parts: nil, payments: [Payment(name: "上门检查费", price: 10, paid: false)]),
        Order(type: .Normal, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .OnGoing, ratingStar: nil, ratingDesc: nil, parts: [Part(name: "六角螺母2.5*3mm", num: 6, price: "10")], payments: [Payment(name: "上门检查费", price: 10, paid: true), Payment(name: "六角螺母2.5*3mm x6", price: 10, paid: true)]),
        Order(type: .Normal, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .Cancelling, ratingStar: nil, ratingDesc: nil, parts: [Part(name: "六角螺母2.5*3mm", num: 6, price: "10")], payments: [Payment(name: "上门检查费", price: 10, paid: true), Payment(name: "六角螺母2.5*3mm x6", price: 10, paid: true)]),
        Order(type: .Normal, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .Cancelling, ratingStar: nil, ratingDesc: nil, parts: [Part(name: "六角螺母2.5*3mm", num: 6, price: "10")], payments: [Payment(name: "上门检查费", price: 10, paid: true), Payment(name: "六角螺母2.5*3mm x6", price: 10, paid: true)]),
        Order(type: .Normal, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .ToBeRating, ratingStar: nil, ratingDesc: nil, parts: [Part(name: "六角螺母2.5*3mm", num: 6, price: "10")], payments: [Payment(name: "上门检查费", price: 10, paid: true), Payment(name: "六角螺母2.5*3mm x6", price: 10, paid: true), Payment(name: "维修费", price: 200, paid: true)]),
        Order(type: .Pack, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: "10.00", image1: nil, image2: nil, status: .ToBeBilled, ratingStar: nil, ratingDesc: nil, parts: nil, payments: [Payment(name: "打包维修费", price: 200, paid: false)]),
        Order(type: .Reservation, desc: "水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了水管漏了", mType: "水维修", mTypeID: "", location: "南航", locationInfo: CLLocation(), fee: nil, image1: nil, image2: nil, status: .ToBeGrabbed, ratingStar: nil, ratingDesc: nil, parts: nil, payments: [])
    ]
    
    var segueOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + orders[section].payments!.count
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
        performSegueWithIdentifier(Constants.SegueID.ShowHandymanOrderDetailSegue, sender: self)
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let order = orders[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanOrderListTopCell", forIndexPath: indexPath)
            
            let typeLabel = cell.viewWithTag(Constants.Tag.HandymanOrderListCellType) as! UILabel
            let mainTypeLabel = cell.viewWithTag(Constants.Tag.HandymanOrderListCellMaintanceType) as! UILabel
            let statusLabel = cell.viewWithTag(Constants.Tag.HandymanOrderListCellStatus) as! UILabel
            let descLabel = cell.viewWithTag(Constants.Tag.HandymanOrderListCellDesc) as! UILabel
            
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
            
            mainTypeLabel.text = order.mType
            
            statusLabel.text = Constants.Status[(order.status?.rawValue)!]
            
            descLabel.text = order.desc
            return cell
        } else if indexPath.row == (order.payments?.count)! + 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanOrderListBottomCell", forIndexPath: indexPath)
            
            let leftButton = cell.viewWithTag(Constants.Tag.HandymanOrderListCellLeftButton) as! UIButton
            leftButton.layer.borderWidth = 0.5
            leftButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            leftButton.layer.cornerRadius = 3
            leftButton.hidden = false
            leftButton.addTarget(self, action: #selector(HandymanOrderListTableViewController.leftButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            
            let rightButton = cell.viewWithTag(Constants.Tag.HandymanOrderListCellRightButton) as! UIButton
            rightButton.hidden = false
            rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            rightButton.backgroundColor = Constants.Color.Primary
            rightButton.layer.cornerRadius = 3
            rightButton.layer.borderWidth = 0
            rightButton.addTarget(self, action: #selector(HandymanOrderListTableViewController.rightButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            
            let reminderLabel = cell.viewWithTag(Constants.Tag.HandymanOrderListCellReminder) as! UILabel
            reminderLabel.hidden = true
            
            switch order.status! {
            case .ToBeBilled:
                leftButton.hidden = true
                rightButton.setTitle("去支付", forState: .Normal)
                
            case .OnGoing:
                leftButton.setTitle("购买配件", forState: .Normal)
                rightButton.setTitle("付维修费", forState: .Normal)
                
            case .Cancelling:
                leftButton.setTitle("同意", forState: .Normal)
                
                rightButton.setTitle("不同意", forState: .Normal)
                rightButton.backgroundColor = UIColor.whiteColor()
                rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                rightButton.layer.borderWidth = 0.5
                rightButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                
                reminderLabel.hidden = false
                
            case .ToBeRating:
                leftButton.setTitle("补购配件", forState: .Normal)
                rightButton.setTitle("去评价", forState: .Normal)
                
            case .ToBeGrabbed:
                leftButton.hidden = true
                rightButton.hidden = true
                
            default:
                leftButton.hidden = true
                rightButton.hidden = true
            }
            
            return cell
        } else {
            let payment = order.payments![indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanOrderListMidCell", forIndexPath: indexPath)
            
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
    
    func leftButtonAction() {
        //performSegueWithIdentifier(Constants.SegueID.ShowPartsMallSegue, sender: self)
    }
    
    func rightButtonAction() {
        //performSegueWithIdentifier(Constants.SegueID.ShowCustomerRatingSegue, sender: self)
    }
}
