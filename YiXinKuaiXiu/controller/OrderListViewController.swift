//
//  OrderListViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/6.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, SMSwipeableTabViewControllerDelegate {

    let customize = false
    let showImageOnButton = true
    var viewControllerDataSourceCollection = [["Delhi", "Gurgaon", "Noida"], ["Mumbai", "Bandra", "Andheri", "Dadar"]]
    
    let titleBarDataSource = ["进行中", "已完成"]
    
    let swipeableView = SMSwipeableTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.viewFrame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)
        
        swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.whiteColor()]
        swipeableView.selectionBarAttributes = [
            SMBackgroundColorAttribute : UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0),
            SMAlphaAttribute : 1.0
        ]
        
        swipeableView.buttonAttributes = [
            SMBackgroundColorAttribute : UIColor.whiteColor(),
            SMAlphaAttribute : 1.0,
            SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 15.0)!,
            SMForegroundColorAttribute : UIColor.darkGrayColor()
        ]
        
        swipeableView.selectionBarHeight = 3.0 //For thin line
        swipeableView.buttonPadding = 0.0 //Default is 8.0
        swipeableView.kSelectionBarSwipeConstant = 2.0
        swipeableView.buttonWidth = UIScreen.mainScreen().bounds.width / 2
        
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMoveToParentViewController(self)
    }
    
    //MARK: SMSwipeableTabViewController Delegate CallBack
    
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
        let listVC = SMSimpleListViewController()
        listVC.dataSource = viewControllerDataSourceCollection[index]
        return listVC
    }

}
