//
//  HandymanInfoViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanInfoViewController: UITableViewController{
    
    var name: String?, age: Int?, telephone: String?, imageUrl: String?, starList: [Int]?, descList: [String]?, dateList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row != 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("handymanInfoTopCell", forIndexPath: indexPath)
                
                if indexPath.row == 0 {
                    cell.textLabel?.text = "姓名"
                    cell.detailTextLabel?.text = name
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "年龄"
                    if age == nil || age == 0 {
                        cell.detailTextLabel?.text = "暂无"
                    } else {
                        cell.detailTextLabel?.text = age?.toString()
                    }
                    
                } else {
                    cell.textLabel?.text = "手机号"
                    cell.detailTextLabel?.text = telephone
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("handymanInfoImgCell", forIndexPath: indexPath)
                
                let imageView = cell.viewWithTag(1) as! UIImageView
                imageView.hnk_setImageFromURL(NSURL(string: imageUrl!)!)
                imageView.clipsToBounds = true
                imageView.setupForImageViewer(Constants.Color.BlackBackground)
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                return tableView.dequeueReusableCellWithIdentifier("handymanInfoRatingTitleCell", forIndexPath: indexPath)
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("handymanInfoRatingCell", forIndexPath: indexPath)
                
                let ratingView = cell.viewWithTag(1) as! FloatRatingView
                let dateLabel = cell.viewWithTag(2) as! UILabel
                let descLabel = cell.viewWithTag(3) as! UILabel
                
                ratingView.rating = Float(starList![indexPath.row - 1])
                dateLabel.text = UtilBox.getDateFromString(dateList![indexPath.row - 1], format: Constants.DateFormat.YMD)
                
                let desc = descList![indexPath.row - 1]
                descLabel.text = desc == "" ? "无评价内容" : desc
                
                return cell
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 3 ? 80 : 44
        } else {
            return indexPath.row == 0 ? 44 : 82
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : (starList?.count)! == 0 ? 0 : (starList?.count)! + 1
    }
}
