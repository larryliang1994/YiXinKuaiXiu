//
//  OrderListViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/6.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, SMSwipeableTabViewControllerDelegate {
    
    let titleBarDataSource = ["进行中", "已完成"]
    
    var cOnGoingTableView, cDoneTableView: CustomerOrderListTableViewController?
    
    var hOnGoingTableView, hDoneTableView: HandymanOrderListTableViewController?
    
    var isFromHomePage = true
    
    var swipeableView :SMSwipeableTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
        initNavBar()
    }
    
    func initView() {
        if Config.Role == Constants.Role.Customer {
            cOnGoingTableView = UtilBox.getController(Constants.ControllerID.CustomerOrderList) as? CustomerOrderListTableViewController
            cOnGoingTableView?.isFromHomePage = isFromHomePage
            cOnGoingTableView?.tableType = 0
            
            cDoneTableView = UtilBox.getController(Constants.ControllerID.CustomerOrderList) as? CustomerOrderListTableViewController
            cDoneTableView?.isFromHomePage = true
            cDoneTableView?.tableType = 1
        } else {
            hOnGoingTableView = UtilBox.getController(Constants.ControllerID.HandymanOrderList) as? HandymanOrderListTableViewController
            hOnGoingTableView?.isFromHomePage = isFromHomePage
            hOnGoingTableView?.tableType = 0
            
            hDoneTableView = UtilBox.getController(Constants.ControllerID.HandymanOrderList) as? HandymanOrderListTableViewController
            hDoneTableView?.isFromHomePage = true
            hDoneTableView?.tableType = 1
        }
        
        swipeableView = SMSwipeableTabViewController()
        
        swipeableView!.titleBarDataSource = titleBarDataSource
        swipeableView!.delegate = self
        swipeableView!.viewFrame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)
        
        swipeableView!.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.whiteColor()]
        swipeableView!.selectionBarAttributes = [
            SMBackgroundColorAttribute : Constants.Color.Primary,
            SMAlphaAttribute : 1.0
        ]
        
        swipeableView!.buttonAttributes = [
            SMBackgroundColorAttribute : UIColor.whiteColor(),
            SMAlphaAttribute : 1.0,
            SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,
            SMForegroundColorAttribute : UIColor.darkGrayColor()
        ]
        
        swipeableView!.segementBarHeight = 39
        swipeableView!.selectionBarHeight = 3.0 //For thin line
        swipeableView!.buttonPadding = 0.0 //Default is 8.0
        swipeableView!.kSelectionBarSwipeConstant = 2.0
        swipeableView!.buttonWidth = UIScreen.mainScreen().bounds.width / 2
        
        self.addChildViewController(swipeableView!)
        self.view.addSubview(swipeableView!.view)
        swipeableView!.didMoveToParentViewController(self)
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    //MARK: SMSwipeableTabViewController Delegate CallBack
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
        if Config.Role == Constants.Role.Customer {
            return index == 0 ? cOnGoingTableView! : cDoneTableView!
        } else {
            return index == 0 ? hOnGoingTableView! : hDoneTableView!
        }
    }
}

