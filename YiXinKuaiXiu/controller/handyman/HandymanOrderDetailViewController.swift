//
//  HandymanOrderDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanOrderDetailViewController: UITableViewController {
    
    @IBOutlet var portraitImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rating: FloatRatingView!
    @IBOutlet var orderCountLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var serviceRating: FloatRatingView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var totalFeeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var mFeeLabel: UILabel!
    @IBOutlet var partFeeLabel: UILabel!
    @IBOutlet var imageCell: UITableViewCell!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture1ImageView: UIImageView!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        self.tableView.layoutIfNeeded()
        
        initNavBar()
    }
    
    func initView() {
        nameLabel.text = order?.senderName!
        
        ratingLabel.text = order?.ratingDesc!
        
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        dateLabel.text = UtilBox.getDateFromString((order?.date)!, format: Constants.DateFormat.YMD)
        
        serviceRating.rating = Float((order?.ratingStar)!)
        
        if order?.type == .Pack {
            feeLabel.text = "无"
            mFeeLabel.text = "无"
            partFeeLabel.text = "无"
            totalFeeLabel.text = "￥" + (order?.fee)!
        } else if order?.type == .Normal {
            feeLabel.text = "￥" + (order?.fee)!
            mFeeLabel.text = "￥" + (order?.mFee)!
            partFeeLabel.text = (order?.partFee)! == "0" ? "无" : "￥" + (order?.partFee)!
            totalFeeLabel.text = "￥" + String(Float((order?.fee)!)! + Float((order?.mFee)!)!)
        }
        
        if order?.image1Url == nil {
            imageCell.hidden = true
        } else if order?.image2Url == nil {
            picture1ImageView.hnk_setImageFromURL(NSURL(string: (order?.image1Url)!)!)
        } else {
            picture1ImageView.hnk_setImageFromURL(NSURL(string: (order?.image1Url)!)!)
            picture2ImageView.hnk_setImageFromURL(NSURL(string: (order?.image2Url)!)!)
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
            title: "呼叫" + order!.senderNum!,
            style: .Default)
        { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string :"tel://" + self.order!.senderNum!)!)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
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
            
        case 2: return order?.type == .Reservation ? 0 : 129
            
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
}
