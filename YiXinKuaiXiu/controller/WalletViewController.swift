//
//  CustomerWalletViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class WalletViewController: UITableViewController, WalletChangeDelegate, UserInfoDelegate {
    
    @IBOutlet var buttonBackgroundView: UIView!
    @IBOutlet var moneyLabel: UILabel!
    
    var delegate: ModifyUserInfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiView()
        
        initNavBar()

        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        refresh()
    }
    
    func intiView() {
        moneyLabel.text = Config.Money == nil ? "0.00" : Config.Money
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "钱包"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func refresh() {
        self.pleaseWait()
        UserInfoModel(userInfoDelegate: self).doGetUserInfo()
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            intiView()
        } else {
            UtilBox.alert(self, message: info)
        }
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
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.SegueID.ShowD2DAccountSegue, sender: self)
            } else if indexPath.row == 1 {
                performSegueWithIdentifier(Constants.SegueID.ShowChangePasswordSegue, sender: self)
            } else if indexPath.row == 2 {
                if Config.BankName == nil {
                    performSegueWithIdentifier(Constants.SegueID.ShowBindBankCardSegue, sender: self)
                } else {
                    performSegueWithIdentifier(Constants.SegueID.ShowBoundBankCardSegue, sender: self)
                }
            }
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
        refresh()
        delegate?.didModify(NSIndexPath(forRow: 0, inSection: 0), value: "")
    }
    
    func didRecharge() {
        moneyLabel.text = Config.Money == nil ? "0.00" : Config.Money
        tableView.reloadData()
        delegate?.didModify(NSIndexPath(forRow: 0, inSection: 0), value: "")
    }

}

protocol WalletChangeDelegate {
    func didChange()
    func didRecharge()
}
