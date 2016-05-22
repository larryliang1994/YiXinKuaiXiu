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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var mType = ""
        let tempString = Config.MTypeIDString!
            .stringByReplacingOccurrencesOfString("[", withString: "")
            .stringByReplacingOccurrencesOfString("]", withString: "")
        let mTypeStrings: [String] = tempString.componentsSeparatedByString(",")
        for var typeString in mTypeStrings {
            mType += UtilBox.findMTypeNameByID(typeString)! + "维修,"
        }
        mType = mType.substringToIndex(mType.endIndex.advancedBy(-1))
        
        mTypeLabel.text = mType
        locationLabel.text = Config.Location
        idNumLabel.text = Config.IDNum
        contactNumLabel.text = Config.ContactName
        contactNumLabel.text = Config.ContactTelephone
        idImageView.hnk_setImageFromURL(NSURL(string: Config.PortraitUrl!)!)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}


