//
//  CustomerOrderDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderDetailViewController: UITableViewController, UserInfoDelegate, OrderDelegate {
    
    @IBOutlet var portraitImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rating: FloatRatingView!
    @IBOutlet var orderCountLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var serviceRating: FloatRatingView!
    @IBOutlet var ratingLabel: UILabel!
    
    @IBOutlet var imageCell: UITableViewCell!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture1ImageView: UIImageView!
    var order: Order?
    
    var name: String?, telephoneNum: String?, sex: Int?, age: Int?, star: Int?, mNum: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        self.tableView.layoutIfNeeded()
        
        initNavBar()
        
        self.pleaseWait()
        UserInfoModel(userInfoDelegate: self).doGetHandymanInfo((order?.graberID)!)
    }
    
    func onGetHandymanInfoResult(result: Bool, info: String, name: String, telephoneNum: String, sex: Int, age: Int, star: Int, mNum: Int) {
        self.clearAllNotice()
        if result {
            self.name = name
            self.telephoneNum = telephoneNum
            self.sex = sex
            self.age = age
            self.star = star
            self.mNum = mNum
            
            nameLabel.text = name
            if mNum != 0 {
                rating.rating = Float(star / mNum)
            } else {
                rating.rating = 0
            }
            orderCountLabel.text = mNum.toString() + "单"
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func initView() {
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = Constants.Color.Gray.CGColor
        
        contactButton.layer.cornerRadius = 3
        contactButton.layer.borderWidth = 0.5
        contactButton.layer.borderColor = Constants.Color.Primary.CGColor
        
        ratingLabel.clipsToBounds = true
        ratingLabel.layer.cornerRadius = 3
        ratingLabel.backgroundColor = Constants.Color.Gray
        
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        dateLabel.text = UtilBox.getDateFromString((order?.date)!, format: Constants.DateFormat.YMD)
    
        if order?.image1 == nil {
            imageCell.hidden = true
        } else if order?.image2 == nil {
            picture2ImageView.image = UtilBox.getAssetThumbnail((order?.image1!.originalAsset)!)
        } else {
            picture1ImageView.image = UtilBox.getAssetThumbnail((order?.image1!.originalAsset)!)
            picture2ImageView.image = UtilBox.getAssetThumbnail((order?.image2!.originalAsset)!)
        }
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func contact(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "呼叫" + self.telephoneNum!,
            style: .Default)
        { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string :"tel://" + self.telephoneNum!)!)
        }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelOrder(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "取消订单",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.pleaseWait()
            
            OrderModel(orderDelegate: self).cancelOrder(self.order!)
        }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func onCancelOrderResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            UtilBox.alert(self, message: "已向对方发出申请，请等待对方确认")
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return indexPath.row == 0 ? 60 : 40
            
        case 1:
            switch indexPath.row {
            case 0: return descLabel.frame.size.height + 24
            case 1: return order?.image1 == nil ? 0 : 70
            case 2: return locationLabel.frame.size.height + 24
            case 3: return 44
            default:    return 44
            }
            
        case 2: return 129
            
        case 3: return order?.state?.rawValue < State.HasBeenRated.rawValue ? 0 : ratingLabel.frame.size.height + 64
            
        default:    return 44
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            performSegueWithIdentifier(Constants.SegueID.ShowHandymanInfoSugue, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let hivc = destination as? HandymanInfoViewController {
            hivc.name = name
            hivc.age = age
            hivc.telephone = telephoneNum
        }
    }
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onPublishOrderResult(result: Bool, info: String) {}
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
}
