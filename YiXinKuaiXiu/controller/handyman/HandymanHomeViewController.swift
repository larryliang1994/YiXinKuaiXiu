//
//  HandymanHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class HandymanHomeViewController: UIViewController, HandymanDrawerDelegate {
    
    @IBOutlet var mapView: BMKMapView!
    @IBOutlet var grabButton: UIButton!

    var drawerController: KYDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        grabButton.backgroundColor = Constants.Color.Primary
        
        grabButton.layer.cornerRadius = 3
        grabButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24)
        
        drawerController = self.navigationController?.parentViewController as? KYDrawerController
        
        drawerController?.drawerWidth = UIScreen.mainScreen().bounds.width * 0.75
        (drawerController?.drawerViewController as! HandymanDrawerViewController).delegate = self
        
        initNavBar()
    }

    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "主页"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func doGrab(sender: UIButton) {
        //showAuditAlertView()
        performSegueWithIdentifier(Constants.SegueID.ShowGrabListSegue, sender: self)
    }
    
    var notAuditYetAlert: OYSimpleAlertController?
    
    func showAuditAlertView() {
        notAuditYetAlert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: notAuditYetAlert!, message: "尚未认证身份", cancelButtonTitle: "取消", cancelButtonAction: #selector(HandymanHomeViewController.auditCancel), confirmButtonTitle: "去认证", confirmButtonAction: #selector(HandymanHomeViewController.doAudit))
    }
    
    // 点击去认证按钮
    func doAudit() {
        notAuditYetAlert?.dismissViewControllerAnimated(true, completion: nil)
        
        performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditIDSegue, sender: self)
    }
    
    // 点击取消
    func auditCancel() {
        notAuditYetAlert?.dismissViewControllerAnimated(true, completion: nil)
        notAuditYetAlert = nil
    }
    
    func didLogout() {
        UtilBox.clearUserDefaults()
        
        UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WelcomeVCNavigation")
            UIApplication.sharedApplication().keyWindow?.rootViewController = controller
            }, completion: nil)
    }
    
    @IBAction func drawerToggle(sender: UIBarButtonItem) {
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Opened, animated: true)
    }
    
    func didSelected(index: Int){
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)
        
        var segue: String = ""
        switch index {
        case 0:
            segue = Constants.SegueID.HandymanDrawerToOrderListSegue
            break
            
        case 1:
            segue = Constants.SegueID.HandymanDrawerToOrderListSegue
            break
            
        case 2:
            segue = Constants.SegueID.HandymanDrawerToWalletSegue
            break
            
        case 3:
            segue = Constants.SegueID.HandymanDrawerToAuditIDSegue
            break
            
        case 4:
            segue = Constants.SegueID.HandymanDrawerToMessageCenterSegue
            break
            
        case 5:
            segue = Constants.SegueID.HandymanDrawerToProjectBidingSegue
            
        default:
            break
        }
        
        performSegueWithIdentifier(segue, sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        //mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        //mapView.delegate = nil // 不用时，置nil
    }
    
    
}
