//
//  CustomerWalletViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class WalletViewController: UITableViewController, WalletChangeDelegate {
    
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var buttonBackgroundView: UIView!
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var rechargeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiView()
        
        initNavBar()

        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    func intiView() {
        withdrawButton.layer.cornerRadius = 3
        withdrawButton.layer.borderWidth = 1
        withdrawButton.layer.borderColor = Constants.Color.Primary.CGColor
        
        rechargeButton.layer.cornerRadius = 3
        rechargeButton.backgroundColor = Constants.Color.Primary
        
        moneyLabel.text = Config.Money == nil ? "0.00" : Config.Money
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "钱包"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func recharge(sender: UIButton) {
        performSegueWithIdentifier(Constants.SegueID.ShowRechargeSegue, sender: self)
    }
    
    @IBAction func goWithDraw(sender: UIButton) {
        performSegueWithIdentifier(Constants.SegueID.ShowWithDrawSegue, sender: self)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 160 : 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier(Constants.SegueID.ShowD2DAccountSegue, sender: self)
        } else if indexPath.row == 1 {
            performSegueWithIdentifier(Constants.SegueID.ShowChangePasswordSegue, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let rvc = destination as? RechargeViewController {
            rvc.delegate = self
        } else if let wdvc = destination as? WithDrawViewController {
            wdvc.delegate = self
        }
    }
    
    func didChange() {
        moneyLabel.text = Config.Money == nil ? "0.00" : Config.Money
    }
}

protocol WalletChangeDelegate {
    func didChange()
}
