//
//  OrderPublishConfirmViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Photos

class OrderPublishConfirmViewController: UITableViewController, PopBottomViewDataSource, PopBottomViewDelegate, PopoverPayDelegate {
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var feeCell: UITableViewCell!
    @IBOutlet var imageCell: UITableViewCell!
    
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var picture3ImageView: UIImageView!
    @IBOutlet var picture4ImageView: UIImageView!
    
    var images: [UIImageView] = []
    
    var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initNavBar()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        self.tableView.layoutIfNeeded()
    }
    
    func initNavBar() {
        let back = UIButton(type: .Custom)
        back.setTitleColor(Constants.Color.Primary, forState: .Normal)
        back.setTitle("主页", forState: .Normal)
        back.titleLabel?.font = UIFont(name: (back.titleLabel?.font?.fontName)!, size: 17)
        back.frame = CGRectMake(0, 0, 43, 43)
        back.addTarget(self, action: #selector(OrderPublishConfirmViewController.goBack), forControlEvents: .TouchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func initView() {
        descLabel.text = order?.desc
        
        locationLabel.text = order?.location
        
        timeLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.YMD)
        
        if order?.type == .Pack {
            feeTitleLabel.text = "打包费"
            feeLabel.text = "￥ " + order!.fee!
        } else if order?.type == .Reservation {
            feeCell.hidden = true
        } else {
            feeLabel.text = "￥ " + order!.fee!
        }
        
        images.append(picture1ImageView)
        images.append(picture2ImageView)
        images.append(picture3ImageView)
        images.append(picture4ImageView)
        
        if order?.images!.count == 0 {
            imageCell.hidden = true
        } else {
            for index in 0...(order?.images!.count)!-1 {
                images[index].image = UtilBox.getAssetThumbnail((order?.images![index].originalAsset)!)
                images[index].clipsToBounds = true
                images[index].setupForImageViewer(Constants.Color.BlackBackground)
            }
        }
    }
    
    @IBAction func doPay(sender: UIButton) {
        let v = PopBottomView(frame: self.view.bounds)
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
    }
    
    func hide(){
        for v in self.view.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        let payPopoverView = UIView.loadFromNibNamed("PayPopoverView") as! PayPopoverView
        payPopoverView.closeButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.feeLabel.text = "￥" + String(UTF8String: (order?.fee!)!)!
        payPopoverView.fee = order!.fee!
        payPopoverView.date = order?.date
        payPopoverView.type = .Fee
        payPopoverView.delegate = self
        payPopoverView.viewController = self
        
        return payPopoverView
    }
    
    func onPayResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("订单发布成功", autoClear: true, autoClearTime: 2)
            Config.NotToHomePage = true
            goBack()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func viewHeight() -> CGFloat {
        return 346
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            if indexPath.row == 0 {
                return descLabel.frame.size.height + 28
            } else if indexPath.row == 2 {
                return locationLabel.frame.size.height + 28
            } else if indexPath.row == 1{
               return order?.images!.count == 0 ? 0 : 70
            } else {
                return 44
            }
        default:
            return 44
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 5
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

}
