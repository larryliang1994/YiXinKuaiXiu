//
//  OrderListTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.SegueID.ShowCustomerOrderDetail, sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("orderListTopCell", forIndexPath: indexPath)
            
            let typeLabel = cell.viewWithTag(Constants.Tag.OrderListCellType) as! UILabel
            typeLabel.clipsToBounds = true
            typeLabel.layer.cornerRadius = 3
            typeLabel.backgroundColor = Constants.Color.Orange
            
            let descLabel = cell.viewWithTag(Constants.Tag.OrderListCellDesc) as! UILabel
            descLabel.text = "订单详情订单详情订单详情订单详情订单详情订单详情订单详情订单详情订单详情订单详情订单详情"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("orderListBottomCell", forIndexPath: indexPath)
            
            let leftButton = cell.viewWithTag(Constants.Tag.OrderListCellLeftButton) as! UIButton
            leftButton.layer.borderWidth = 0.5
            leftButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            leftButton.layer.cornerRadius = 3
            leftButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            leftButton.addTarget(self, action: #selector(OrderListTableViewController.leftButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            
            let rightButton = cell.viewWithTag(Constants.Tag.OrderListCellRightButton) as! UIButton
            rightButton.backgroundColor = Constants.Color.Primary
            rightButton.layer.cornerRadius = 3
            rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            rightButton.addTarget(self, action: #selector(OrderListTableViewController.rightButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            
            //let badge = JSBadgeView()
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("orderListMidCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "上门检查费"
            cell.detailTextLabel?.text = "¥10.00(已支付)"
            
            let origin = cell.contentView.frame
            let background = UIView()
            background.frame = CGRect(x: origin.minX + 10, y: origin.minY, width: origin.width - 20, height: origin.height + 10)
            background.layer.cornerRadius = 3
            background.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.5)
            
            cell.addSubview(background)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("orderListMidCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "六角螺母2.5*3mm x6"
            cell.detailTextLabel?.text = "¥10.00(已支付)"
            
            let origin = cell.contentView.frame
            let background = UIView()
            background.frame = CGRect(x: origin.minX + 10, y: origin.minY - 10, width: origin.width - 20, height: origin.height + 10)
            background.layer.cornerRadius = 3
            background.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.5)
            
            cell.addSubview(background)
            
            return cell
        }
    }
    
    func leftButtonAction() {
        performSegueWithIdentifier(Constants.SegueID.ShowPartsMallSegue, sender: self)
    }
    
    func rightButtonAction() {
        performSegueWithIdentifier(Constants.SegueID.ShowCustomerRatingSegue, sender: self)
    }
}
