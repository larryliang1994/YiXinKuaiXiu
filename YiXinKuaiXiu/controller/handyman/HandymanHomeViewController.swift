//
//  HandymanHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class HandymanHomeViewController: UIViewController, HandymanDrawerDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, GetNearbyDelegate, ModifyUserInfoDelegate {
    
    @IBOutlet var mapView: BMKMapView!
    
    var drawerController: KYDrawerController?
    
    var personList: [Person]?
    
    let locationService = BMKLocationService()
    
    var gotLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initNavBar()
    }
    
    func initView() {
        drawerController = self.navigationController?.parentViewController as? KYDrawerController
        
        drawerController?.drawerWidth = UIScreen.mainScreen().bounds.width * 0.75
        (drawerController?.drawerViewController as! HandymanDrawerViewController).delegate = self
        
        mapView.zoomLevel = 18
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
    }

    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "主页"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if gotLocation {
            locationService.stopUserLocationService()
        } else {
            mapView.updateLocationData(userLocation)
            mapView.removeAnnotations(mapView.annotations)
            
            let localLatitude=userLocation.location.coordinate.latitude
            let localLongitude=userLocation.location.coordinate.longitude
            
            Config.CurrentLocationInfo = CLLocation(latitude: localLatitude, longitude: localLongitude)
            
            GetNearbyModel(getNearbyDelegate: self).doGetNearby(localLatitude.description, longitude: localLongitude.description, distance: 30)
            
            gotLocation = true
        }
    }
    
    func didModify(indexPath: NSIndexPath, value: String) {
        (drawerController?.drawerViewController as! HandymanDrawerViewController).tableView.reloadData()
    }
    
    func onGetNearbyResult(result: Bool, info: String, personList: [Person]) {
        if result {
            self.personList = personList
            
            for var person in personList {
                let annotation = BMKPointAnnotation()
                let lat = CLLocationDegrees(person.latitude!)
                let lot = CLLocationDegrees(person.longitude!)
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lot!)
                
                mapView.addAnnotation(annotation)
            }
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let view =  BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "aaa")
        view.animatesDrop = true
        view.image = UIImage(named: "customerLocation")
        
        return view
    }
    
    @IBAction func doGrab(sender: UIButton) {
        if Config.Audited == 0 && (Config.Name == nil || Config.Name == "") && (Config.IDNum == nil || Config.IDNum == "") {
            showAuditAlertView()
        } else if Config.Audited == 0 && Config.Name != nil && Config.Name != "" && Config.IDNum != nil && Config.IDNum != "" {
            showModifyAuditAlertView()
        } else {
            performSegueWithIdentifier(Constants.SegueID.ShowGrabListSegue, sender: self)
        }
    }
    
    var notAuditYetAlert: OYSimpleAlertController?
    
    func showAuditAlertView() {
        notAuditYetAlert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: notAuditYetAlert!, message: "尚未认证身份", cancelButtonTitle: "取消", cancelButtonAction: #selector(HandymanHomeViewController.auditCancel), confirmButtonTitle: "去认证", confirmButtonAction: #selector(HandymanHomeViewController.doAudit))
    }
    
    func showModifyAuditAlertView() {
        notAuditYetAlert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: notAuditYetAlert!, message: "身份认证审核中", cancelButtonTitle: "取消", cancelButtonAction: #selector(HandymanHomeViewController.auditCancel), confirmButtonTitle: "修改", confirmButtonAction: #selector(HandymanHomeViewController.doAudit))
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
        
        switch index {
        case 0:
            //UserInfo
            let userInfoVC = UtilBox.getController(Constants.ControllerID.UserInfo) as! UserInfoViewController
            self.navigationController?.showViewController(userInfoVC, sender: self)
            
        case 1:
            let orderListVC = UtilBox.getController(Constants.ControllerID.OrderList) as! OrderListViewController
            self.navigationController?.showViewController(orderListVC, sender: self)
            
        case 2:
            let walletVC = UtilBox.getController(Constants.ControllerID.Wallet) as! WalletViewController
            walletVC.delegate = self
            self.navigationController?.showViewController(walletVC, sender: self)
            
        case 3:
            if Config.Audited == 0 {
                performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditIDSegue, sender: self)
            } else {
                performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToAuditedSegue, sender: self)
            }
            
        case 4:
            let messageCenterVC = UtilBox.getController(Constants.ControllerID.MessageCenter) as! MessageCenterViewController
            self.navigationController?.showViewController(messageCenterVC, sender: self)
            
        case 5:
            performSegueWithIdentifier(Constants.SegueID.HandymanDrawerToProjectBidingSegue, sender: self)
            
        default:    break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        gotLocation = false
        locationService.delegate = self
        locationService.startUserLocationService()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil // 不用时，置nil
        
        locationService.delegate = nil
        locationService.stopUserLocationService()
    }
}
