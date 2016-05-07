//
//  OrderTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 16 : 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderTypeCell")
        
        cell?.layer.cornerRadius = 3
        cell?.contentView.layer.cornerRadius = 3
        
        let image = cell?.viewWithTag(Constants.Tag.OrderTypeCellImage) as! UIImageView
        let title = cell?.viewWithTag(Constants.Tag.OrderTypeCellTitle) as! UILabel
        let desc = cell?.viewWithTag(Constants.Tag.OrderTypeCellDesc) as! UILabel
        
        if indexPath.section == 0 {
            image.image = UIImage(named: "normalOrder")
            title.text = Constants.Types[0]
            desc.text = "即时发单，需支付上门检查费。维修费与物料费另算。"
        } else if indexPath.section == 1 {
            image.image = UIImage(named: "packOrder")
            title.text = Constants.Types[1]
            desc.text = "即时发单，一次性支付所有费用。"
        } else if indexPath.section == 2 {
            image.image = UIImage(named: "reservationOrder")
            title.text = Constants.Types[2]
            desc.text = "预约维修，不收取上门检查费。"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        
        let title = cell?.viewWithTag(Constants.Tag.OrderTypeCellTitle) as! UILabel
        type = title.text
        
        performSegueWithIdentifier(Constants.SegueID.PubilshOrderSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let opvc = destination as? OrderPublishViewController {
            opvc.title = type!
        }
    }
}
