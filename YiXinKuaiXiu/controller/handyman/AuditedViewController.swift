//
//  AuditedViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/17.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class AuditedViewController: UITableViewController {

    @IBOutlet var mTypeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var idNumLabel: UILabel!
    @IBOutlet var idImageView: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var contactNumLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Config.Name == nil || Config.Location == nil || Config.IDNum == nil || Config.PortraitUrl == nil {
            let alert = UIAlertController(
                title: nil,
                message: "后台数据出错，请联系客服修复",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alert.addAction(UIAlertAction(
                title: "好的",
                style: .Cancel)
            { (action: UIAlertAction) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                }
            )
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            initView()
            
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    private func initView() {
        var mType = ""
        let tempString = Config.MTypeIDString!
            .stringByReplacingOccurrencesOfString("[", withString: "")
            .stringByReplacingOccurrencesOfString("]", withString: "")
        let mTypeStrings: [String] = tempString.componentsSeparatedByString(",")
        for var typeString in mTypeStrings {
            if typeString == "" {
                continue
            }
            mType += UtilBox.findMTypeNameByID(typeString)! + "维修,"
        }
        mType = mType.substringToIndex(mType.endIndex.advancedBy(-1))
        
        mTypeLabel.text = mType
        locationLabel.text = Config.Location
        idNumLabel.text = Config.IDNum
        contactNameLabel.text = Config.ContactName
        contactNumLabel.text = Config.ContactTelephone
        nameLabel.text = Config.Name
        
        idImageView.clipsToBounds = true
        idImageView.hnk_setImageFromURL(NSURL(string: Config.PortraitUrl!)!)
        idImageView.setupForImageViewer(Constants.Color.BlackBackground)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 30
    }
}


