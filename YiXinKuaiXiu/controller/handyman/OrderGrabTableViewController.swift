//
//  OrderGrabTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderGrabTableViewController: UITableViewController {
    
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

        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
        tableView.tableFooterView = footer
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
            typeLabel.backgroundColor = Constants.Color.Primary
            typeLabel.text = "打包"
            feeLabel.text = "打包费" + " ￥" + String(order.fee!)
        } else {
            typeLabel.backgroundColor = Constants.Color.Blue
            typeLabel.text = "预约"
            feeImg.hidden = true
            feeLabel.hidden = true
        }
        
        descLabel.text = order.desc
        
        maintenanceTypeLabel.text = order.mType
        
        distanceLabel.text = "距离您3公里"
        
        timeLabel.text = "3月29日 18:30"
        
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 2
        button.layer.borderColor = Constants.Color.Primary.CGColor

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueOrder = orders[indexPath.section]
        performSegueWithIdentifier(Constants.SegueID.ShowOrderGrabDetailSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let ogdvc = destination as? OrderGrabDetailViewController {
            ogdvc.order = segueOrder
        }
    }
}
