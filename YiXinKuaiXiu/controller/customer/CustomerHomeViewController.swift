//
//  CustomerHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class CustomerHomeViewController: UIViewController, CustomerDrawerDelegate, CustomerPersonInfoDelgate {

    @IBOutlet var publishButton: UIButton!
    @IBOutlet var mapView: BMKMapView!
    
    var drawerController: KYDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        publishButton.backgroundColor = Constants.Color.Primary
        publishButton.layer.cornerRadius = 3
        publishButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24)
        
        drawerController = self.navigationController?.parentViewController as? KYDrawerController
        
        drawerController?.drawerWidth = UIScreen.mainScreen().bounds.width * 0.75
        
        (drawerController?.drawerViewController as! CustomerDrawerViewController).delegate = self
        
        initNavBar()
    }
    
    // 初始化NavigationBar
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "主页"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func drawerToggle(sender: UIBarButtonItem) {
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Opened, animated: true)
    }
    
    func didSelected(index: Int){
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)
        
        var segue: String = ""
        switch index {
        case 0:
            segue = Constants.SegueID.CustomerDrawerToPersonalInfoSegue
            break
            
        case 1:
            segue = Constants.SegueID.CustomerDrawerToOrderListSegue
            break
            
        case 2:
            segue = Constants.SegueID.CustomerDrawerToMessageCenterSegue
            break
            
        case 3:
            segue = Constants.SegueID.CustomerDrawerToMallSegue
            break
            
        default:
            break
        }
        
        performSegueWithIdentifier(segue, sender: self)
    }
    
    func didLogout() {
        UtilBox.clearUserDefaults()
        
        UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WelcomeVCNavigation")
            UIApplication.sharedApplication().keyWindow?.rootViewController = controller
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let cpivc = destination as? CustomerPersonInfoViewController {
            cpivc.delegate = self
        }
    }
    
    func didModify() {
        (drawerController?.drawerViewController as! CustomerDrawerViewController).tableView.reloadData()
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

protocol CustomerPersonInfoDelgate {
    func didModify()
}
