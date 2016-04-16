//
//  OrderGrabViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderGrabViewController: UIViewController, SMSwipeableTabViewControllerDelegate {

    let titleBarDataSource = ["全部", "5公里内", "5-10公里", "10-30公里", "30公里以上"]
    
    let swipeableView = SMSwipeableTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.viewFrame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)
        
        swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.whiteColor()]
        swipeableView.selectionBarAttributes = [
            SMBackgroundColorAttribute : Constants.Color.Primary,
            SMAlphaAttribute : 1.0
        ]
        
        swipeableView.buttonAttributes = [
            SMBackgroundColorAttribute : UIColor.whiteColor(),
            SMAlphaAttribute : 1.0,
            SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 11.0)!,
            SMForegroundColorAttribute : UIColor.lightGrayColor()
        ]
        
        swipeableView.segementBarHeight = 39
        swipeableView.selectionBarHeight = 3.0
        swipeableView.buttonPadding = 0.0
        swipeableView.kSelectionBarSwipeConstant = 5.0
        swipeableView.buttonWidth = UIScreen.mainScreen().bounds.width / 5
        
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMoveToParentViewController(self)
        
        initNavBar()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    //MARK: SMSwipeableTabViewController Delegate CallBack
    
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let list = storyboard.instantiateViewControllerWithIdentifier("OrderGrabTableViewController")
        return list
    }

}
