//
//  CustomerOrderDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderDetailViewController: UITableViewController, UserInfoDelegate, OrderDelegate, PopBottomViewDelegate, PopBottomViewDataSource {
    
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var portraitImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rating: FloatRatingView!
    @IBOutlet var orderCountLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var serviceRating: FloatRatingView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var contactButton: PrimaryButton!
    @IBOutlet var contactButtonWidth: NSLayoutConstraint!
    @IBOutlet var contactButtonLeading: NSLayoutConstraint!
    @IBOutlet var totalFeeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var mFeeLabel: UILabel!
    @IBOutlet var partFeeLabel: UILabel!
    @IBOutlet var showPartDetailButton: UIButton!
    
    @IBOutlet var imageCell: UITableViewCell!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var ratingCell: UITableViewCell!
    
    var delegate: OrderListChangeDelegate?
    
    var order: Order?
    
    var name: String?, telephoneNum: String?, sex: Int?, age: Int?, star: Int?, mNum: Int?, portraitUrl: String? ,starList: [Int]?, descList: [String]?, dateList: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        self.tableView.layoutIfNeeded()
        
        initNavBar()
        
        if order?.state != .NotPayFee && order?.state != .PaidFee {
            self.pleaseWait()
            UserInfoModel(userInfoDelegate: self).doGetHandymanInfo((order?.graberID)!)
        } else {
            nameLabel.text = "待抢单"
            rating.rating = 0
            orderCountLabel.hidden = true
            contactButton.hidden = true
            contactButtonWidth.constant = 0
            contactButtonLeading.constant = 0
        }
    }
    
    func onGetHandymanInfoResult(result: Bool, info: String, name: String, telephoneNum: String, sex: Int, age: Int, star: Int, mNum: Int, portraitUrl: String, starList: [Int], descList: [String], dateList: [String]) {
        self.clearAllNotice()
        if result {
            self.name = name
            self.telephoneNum = telephoneNum
            self.sex = sex
            self.age = age
            self.star = star
            self.mNum = mNum
            self.portraitUrl = portraitUrl
            self.starList = starList
            self.descList = descList
            self.dateList = dateList
            
            portraitImageView.clipsToBounds = true
            portraitImageView.hnk_setImageFromURL(NSURL(string: portraitUrl)!)
            
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
        if order?.state?.rawValue < State.HasBeenRated.rawValue {
            ratingLabel.hidden = true
            serviceRating.hidden = true
            ratingCell.hidden = true
        } else {
            ratingLabel.text = order?.ratingDesc!
            serviceRating.rating = Float((order?.ratingStar)!)
        }
        
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        dateLabel.text = UtilBox.getDateFromString((order?.date)!, format: Constants.DateFormat.YMD)
        
        if order?.type == .Pack {
            feeLabel.text = "￥" + (order?.fee)!
            mFeeLabel.text = "无"
            partFeeLabel.text = "无"
            totalFeeLabel.text = "￥" + (order?.fee)!
            feeTitleLabel.text = "打包费"
            showPartDetailButton.hidden = true
        } else if order?.type == .Normal {
            feeLabel.text = "￥" + (order?.fee)!
            //mFeeLabel.text = "￥" + (order?.mFee)!
            mFeeLabel.text = (order?.mFee)! == "0" ? "无" : "￥" + (order?.mFee)!
            partFeeLabel.text = (order?.partFee)! == "0" ? "无" : "￥" + (order?.partFee)!
            totalFeeLabel.text = "￥" + String(Float((order?.fee)!)! + Float((order?.mFee)!)! + Float((order?.partFee)!)!)
            
            if (order?.partFee)! == "0" {
                showPartDetailButton.hidden = true
            }
        }
        
        if order?.image1Url == nil {
            imageCell.hidden = true
        } else if order?.image2Url == nil {
            picture1ImageView.image = nil
            picture2ImageView.hnk_setImageFromURL(NSURL(string: (order?.image1Url)!)!)
        } else {
            picture1ImageView.hnk_setImageFromURL(NSURL(string: (order?.image1Url)!)!)
            picture2ImageView.hnk_setImageFromURL(NSURL(string: (order?.image2Url)!)!)
        }
        
        picture1ImageView.clipsToBounds = true
        picture2ImageView.clipsToBounds = true
        picture1ImageView.setupForImageViewer(Constants.Color.BlackBackground)
        picture2ImageView.setupForImageViewer(Constants.Color.BlackBackground)
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func showPartDetail(sender: UIButton) {
        let v = PopBottomView(frame: self.view.bounds)
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
    }
    
    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        let partDetailPopover = UIView.loadFromNibNamed("PartDetailPopover") as! PartDetailPopover
        
        partDetailPopover.parts = (order?.parts)!
        
        return partDetailPopover
    }
    
    func viewHeight() -> CGFloat {
        return 225
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func viewWillAppear() {
        tableView.scrollEnabled = false
    }
    
    func viewWillDisappear() {
        tableView.scrollEnabled = true
    }
    
    @IBAction func contact(sender: UIButton) {
        if self.telephoneNum == nil {
            return
        }
        
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
            if order?.state != .NotPayFee && order?.state != .PaidFee {
                UtilBox.alert(self, message: "已向对方发出申请，请等待对方确认")
            } else {
                self.noticeSuccess("取消成功", autoClear: true, autoClearTime: 2)
            }
            delegate?.didChange()
            self.navigationController?.popViewControllerAnimated(true)
            
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ? 60 : 49
            
        case 1:
            switch indexPath.row {
            case 0: return descLabel.frame.size.height + 24
            case 1: return order?.image1Url == nil ? 0 : 70
            case 2: return locationLabel.frame.size.height + 24
            case 3: return 44
            default:    return 44
            }
            
        case 2:
            if order?.type == .Normal {
                return 129
            } else if order?.type == .Pack {
                return 74
            } else {
                return 0
            }
            
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
            if (order?.state?.rawValue)! >= (State.HasBeenGrabbed.rawValue) {
                performSegueWithIdentifier(Constants.SegueID.ShowHandymanInfoSugue, sender: self)
            }
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
            hivc.imageUrl = portraitUrl
            hivc.starList = starList
            hivc.descList = descList
            hivc.dateList = dateList
        }
    }
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onPublishOrderResult(result: Bool, info: String) {}
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}
