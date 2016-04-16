//
//  HandymanHomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class HandymanHomeViewController: UIViewController {
    
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
        //(drawerController?.drawerViewController as! HandymanDrawerViewController).delegate = self
        
        initNavBar()
    }

    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "主页"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func doGrab(sender: UIButton) {
        performSegueWithIdentifier(Constants.SegueID.ShowGrabListSegue, sender: self)
    }
    
    @IBAction func drawerToggle(sender: UIBarButtonItem) {
        drawerController?.setDrawerState(KYDrawerController.DrawerState.Opened, animated: true)
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
