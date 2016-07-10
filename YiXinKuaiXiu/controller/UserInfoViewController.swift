//
//  CustomerPersonInfoViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class UserInfoViewController: UITableViewController, ModifyUserInfoDelegate, ChooseLocationDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var addressCell: UITableViewCell!
    @IBOutlet var companyCell: UITableViewCell!
    @IBOutlet var walletCell: UITableViewCell!
    @IBOutlet var couponCell: UITableViewCell!
    
    var selectedIndex: NSIndexPath?
    
    var delegate: ModifyUserInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        initNavBar()
    }
    
    func initView() {
        nameLabel.text = Config.Name == nil ? "请选择" : Config.Name
        ageLabel.text = Config.Age == nil ? "请选择" : Config.Age
        telephoneLabel.text = Config.TelephoneNum == nil ? "请选择" : Config.TelephoneNum
        locationLabel.text = Config.Location == nil ? "请选择" : Config.Location
        companyLabel.text = Config.Company == nil ? "请选择" : Config.Company
        
        if Config.Role == Constants.Role.Handyman {
            addressCell.hidden = true
            companyCell.hidden = true
            walletCell.hidden = true
            couponCell.hidden = true
        }
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 2:
            tableView.cellForRowAtIndexPath(indexPath)?.selected = false
            
        case 0: fallthrough
        case 1: fallthrough
        case 4:
            selectedIndex = indexPath
            performSegueWithIdentifier(Constants.SegueID.ModifyUserInfoSefue, sender: self)
            
        case 3:
            let chooseLocationVC = UtilBox.getController(Constants.ControllerID.ChooseLocation) as! ChooseLocationTableViewController
            chooseLocationVC.delegate = self
            self.navigationController?.showViewController(chooseLocationVC, sender: self)
            
        case 5:
            let couponVC = UtilBox.getController(Constants.ControllerID.Coupon) as! CouponViewController
            couponVC.justCheck = true
            self.navigationController?.showViewController(couponVC, sender: self)
            
        case 6:
            let walletVC = UtilBox.getController(Constants.ControllerID.Wallet) as! WalletViewController
            self.navigationController?.showViewController(walletVC, sender: self)
            
        default:    break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let cpimvc = destination as? UserInfoModifyViewController {
            let cell = tableView.cellForRowAtIndexPath(selectedIndex!)
            let text = cell?.textLabel?.text
            var content = cell?.detailTextLabel?.text
            
            if content == "请选择" {
                content = nil
            }
            
            cpimvc.title = text
            cpimvc.content = content
            cpimvc.delegate = self
            cpimvc.indexPath = selectedIndex
        }
    }
    
    func didModify(indexPath: NSIndexPath, value: String) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.detailTextLabel?.text = value
        
        delegate?.didModify(NSIndexPath(), value: "")
    }
    
    func didChooseLocation(name: String, locationInfo: CLLocation) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        cell?.detailTextLabel?.text = name
    }
}
