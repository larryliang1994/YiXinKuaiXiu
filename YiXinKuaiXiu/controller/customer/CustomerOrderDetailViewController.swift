//
//  CustomerOrderDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerOrderDetailViewController: UITableViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = Constants.Color.Gray.CGColor
        
        contactButton.layer.cornerRadius = 3
        contactButton.layer.borderWidth = 0.5
        contactButton.layer.borderColor = Constants.Color.Primary.CGColor
        
        ratingLabel.clipsToBounds = true
        ratingLabel.layer.cornerRadius = 3
        ratingLabel.backgroundColor = Constants.Color.Gray
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        self.tableView.layoutIfNeeded()
        
        initNavBar()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return indexPath.row == 0 ? 60 : 40
            
        case 1:
            switch indexPath.row {
            case 0: return descLabel.frame.size.height + 24
            case 1: return 70
            case 2: return locationLabel.frame.size.height + 24
            case 3: return 44
            default:    return 44
            }
            
        case 2: return 129
            
        case 3: return ratingLabel.frame.size.height + 64
            
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
}
