//
//  CouponViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GetInitialInfoDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var delegate: ChooseCouponDelegate?
    
    var justCheck: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.pleaseWait()
        GetInitialInfoModel(getInitialInfoDelegate: self).getCouponList()
    }
    
    func initView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        if justCheck {
            cancelButton.enabled = false
            cancelButton.title = ""
        }
    }
    
    func onGetCouponListResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            if Config.CouponList.count == 0 || justCheck {
                cancelButton.enabled = false
                if Config.CouponList.count == 0 {
                    self.tableView.backgroundView = UtilBox.getEmptyView("暂无可用抵用券")
                }
            } else {
                self.tableView.backgroundView = nil
            }
            
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        delegate?.didChooseCoupon(nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 16 : 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Config.CouponList.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("couponCell", forIndexPath: indexPath)
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.cornerRadius = 3
        cell.contentView.layer.cornerRadius = 3
        
        let feeLabel = cell.viewWithTag(1) as! UILabel
        let usageLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(3) as! UILabel
        let dateLabel = cell.viewWithTag(4) as! UILabel
        let usedLabel = cell.viewWithTag(5) as! UILabel
        
        let coupon = Config.CouponList[indexPath.section]
        feeLabel.text = coupon.fee!.toString()
        usageLabel.text = "抵用" + coupon.fee!.toString() + "元"
        descLabel.text = coupon.desc
        dateLabel.text = "获取日期：" + UtilBox.getDateFromString(coupon.date!, format: Constants.DateFormat.YMD)
        usedLabel.text = coupon.used! ? "已使用" : "可用"
        usedLabel.textColor = coupon.used! ? UIColor.darkGrayColor() : Constants.Color.Primary
        //cell.backgroundColor = coupon.used! ? UIColor.groupTableViewBackgroundColor() : UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let coupon = Config.CouponList[indexPath.section]
        if coupon.used! || justCheck {
            tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        } else {
            delegate?.didChooseCoupon(coupon)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

}

protocol ChooseCouponDelegate {
    func didChooseCoupon(coupon: Coupon?)
}
