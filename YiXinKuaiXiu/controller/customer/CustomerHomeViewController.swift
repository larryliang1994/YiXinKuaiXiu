//
//  CustomerHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class CustomerHomeViewController: UIViewController, CustomerDrawerDelegate, ModifyUserInfoDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, GetNearbyDelegate {

    @IBOutlet var mapView: BMKMapView!
    
    var personList: [Person]?
    
    var drawerController: KYDrawerController?
    
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
        
        (drawerController?.drawerViewController as! CustomerDrawerViewController).delegate = self
        
        mapView.zoomLevel = 18
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if gotLocation {
            locationService.stopUserLocationService()
        } else {
            mapView.updateLocationData(userLocation)
            
            mapView.removeAnnotations(mapView.annotations)
        
            let localLatitude=userLocation.location.coordinate.latitude
            let localLongitude=userLocation.location.coordinate.longitude
        
            GetNearbyModel(getNearbyDelegate: self).doGetNearby(localLatitude.description, longitude: localLongitude.description, distance: 30)
            
            gotLocation = true
        }
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
        view.image = UIImage(named: "handymanLocation")
        
        return view
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
        
        if let cpivc = destination as? UserInfoViewController {
            cpivc.delegate = self
        }
    }
    
    func didModify(indexPath: NSIndexPath, value: String) {
        (drawerController?.drawerViewController as! CustomerDrawerViewController).tableView.reloadData()
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
