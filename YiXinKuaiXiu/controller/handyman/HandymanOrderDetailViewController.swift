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
    @IBOutlet var orderNoLabel: UILabel!
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
        
        orderNoLabel.text = order?.date!
        
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
        } else {
            feeLabel.text = "无"
            mFeeLabel.text = "无"
            partFeeLabel.text = "无"
            totalFeeLabel.text = "无"
            showPartDetailButton.hidden = true
        }
        
        if order?.state?.rawValue < State.HasBeenRated.rawValue {
            ratingCell.hidden = true
        }
        
        images.append(picture1ImageView)
        images.append(picture2ImageView)
        images.append(picture3ImageView)
        images.append(picture4ImageView)
        
        if order?.imageUrls!.count == 0 {
            for index in 0...3 {
                images[index].alpha = 0
            }
        } else {
            for index in 0...(order?.imageUrls!.count)!-1 {
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
        UtilBox.makeCall(self, telephoneNum: self.order!.senderNum!)
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0: return indexPath.row == 0 ? 60 : 49
//            
//        case 1:
//            switch indexPath.row {
//            case 0: return descLabel.frame.size.height + 24
//            case 1: return order?.imageUrls!.count == 0 ? 0 : 70
//            case 2: return locationLabel.frame.size.height + 24
//            case 3: return 44
//            default:    return 44
//            }
//            
//        case 2: return order?.type == .Reservation ? 0 : 129
//            
//        case 3: return order?.state?.rawValue < State.HasBeenRated.rawValue ? 0 : ratingLabel.frame.size.height + 64
//        //case 3: return order?.state?.rawValue < State.HasBeenRated.rawValue ? 0 : UITableViewAutomaticDimension
//            
//        default:    return 44
//        }
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return order?.state?.rawValue < State.HasBeenRated.rawValue ? 3 : 4
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if order?.state?.rawValue < State.HasBeenRated.rawValue && section == 2 {
            return 30
        } else if order?.state?.rawValue == State.HasBeenRated.rawValue && section == 3 {
            return 30
        } else {
            return 9
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (order?.state?.rawValue < State.HasBeenRated.rawValue && section == 2) || (order?.state?.rawValue == State.HasBeenRated.rawValue && section == 3) {
            let button = UIButton(frame: CGRectMake(0, 0, 30, 200))
            button.userInteractionEnabled = true
            button.setTitle("客户服务热线：025-52255155", forState: .Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            button.titleLabel?.font = UIFont(name: (button.titleLabel?.font?.fontName)!, size: 15)
            button.addTarget(self, action: #selector(makeCall), forControlEvents: .TouchUpInside)
            return button
        } else {
            return nil
        }
    }
    
    func makeCall() {
        UtilBox.makeCall(self, telephoneNum: "02552255155")
    }
}
