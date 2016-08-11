//
//  HandymanOrderDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanOrderDetailViewController: UITableViewController, PopBottomViewDelegate, PopBottomViewDataSource {
   
    @IBOutlet var showPartDetailButton: UIButton!
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
    @IBOutlet var ratingCell: UITableViewCell!
    
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture3ImageView: UIImageView!
    @IBOutlet var picture4ImageView: UIImageView!
    
    var images: [UIImageView] = []
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.layoutIfNeeded()
        
        initNavBar()
    }
    
    func initView() {
        nameLabel.text = order?.senderName!
        
        ratingLabel.text = order?.ratingDesc!
        
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        orderCountLabel.text = order!.senderTotalNum!.toString() + "单"
        
        dateLabel.text = UtilBox.getDateFromString((order?.date)!, format: Constants.DateFormat.YMD)
        
        serviceRating.rating = Float((order?.ratingStar)!)
        
        if order?.type == .Pack {
            feeLabel.text = "无"
            mFeeLabel.text = "无"
            partFeeLabel.text = "无"
            totalFeeLabel.text = "￥" + (order?.fee)!
        } else if order?.type == .Urgent {
            feeLabel.text = "￥" + (order?.fee)!
            mFeeLabel.text = "￥" + (order?.mFee)!
            partFeeLabel.text = (order?.partFee)! == "0" ? "无" : "￥" + (order?.partFee)!
            totalFeeLabel.text = "￥" + String(Float((order?.fee)!)! + Float((order?.mFee)!)!)
        }
        
        if order?.state?.rawValue < State.HasBeenRated.rawValue {
            ratingCell.hidden = true
        }
        
        images.append(picture1ImageView)
        images.append(picture2ImageView)
        images.append(picture3ImageView)
        images.append(picture4ImageView)
        
        if order?.imageUrls!.count == 0 {
            imageCell.hidden = true
        } else {
            for var index in 0...(order?.imageUrls!.count)!-1 {
                images[index].hnk_setImageFromURL(NSURL(string: (order?.imageUrls![index])!)!)
                images[index].clipsToBounds = true
                images[index].setupForImageViewer(Constants.Color.BlackBackground)
            }
        }
        
        if (order?.partFee)! == "0" {
            showPartDetailButton.hidden = true
        }
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
        case 0: return indexPath.row == 0 ? 60 : 49
            
        case 1:
            switch indexPath.row {
            case 0: return descLabel.frame.size.height + 24
            case 1: return order?.imageUrls!.count == 0 ? 0 : 70
            case 2: return locationLabel.frame.size.height + 24
            case 3: return 44
            default:    return 44
            }
            
        case 2: return order?.type == .Reservation ? 0 : 129
            
        case 3: return order?.state?.rawValue < State.HasBeenRated.rawValue ? 0 : ratingLabel.frame.size.height + 64
        //case 3: return order?.state?.rawValue < State.HasBeenRated.rawValue ? 0 : UITableViewAutomaticDimension
            
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
