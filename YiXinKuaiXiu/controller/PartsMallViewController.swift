//
//  PartsMallViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PartsMallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopBottomViewDataSource,PopBottomViewDelegate {

    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomSeperator: UIView!
    @IBOutlet var leftTableView: UITableView!
    @IBOutlet var numBadge: SwiftBadge!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var rightTableView: UITableView!
    
    let category = ["金属配件", "塑料配件", "冷却剂", "油漆", "锁具", "其他"]
    let titles = ["十字钉2.5*3mm", "十字钉3*12mm", "一字钉3*12mm", "六角螺母2.5*3mm"]
    let price = ["¥ 0.5", "¥ 0.5", "¥ 0.5", "¥ 0.5"]
    
    var popoverName = ""
    
    var lastPick = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payButton.layer.cornerRadius = 3
        payButton.backgroundColor = Constants.Color.Orange
        
        numBadge.badgeColor = Constants.Color.Orange
        
        leftTableView.tableHeaderView = nil
        leftTableView.backgroundColor = Constants.Color.Gray
        
        rightTableView.tableHeaderView = nil
        rightTableView.tableFooterView = UIView()
        rightTableView.backgroundColor = UIColor.whiteColor()
        
//        let constraint = NSLayoutConstraint(item: bottomSeperator!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0.5)
//        bottomSeperator?.addConstraint(constraint)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func hide(container: UIView){
        for v in container.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    @IBAction func showShoppingCart(sender: UIButton) {
        let v = PopBottomView(frame: containerView.bounds)
        popoverName = "ShoppingCartPopoverView"
        v.dataSource = self
        v.delegate = self
        v.showInView(containerView)
    }
    
    @IBAction func settlement(sender: UIButton) {
        if popoverName != "" {
            hide(containerView)
        }
        
        let v = PopBottomView(frame: self.view.bounds)
        popoverName = "ShoppingCartPayPopoverView"
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
    }

    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        if popoverName == "ShoppingCartPopoverView" {
            let payPopoverView = UIView.loadFromNibNamed(popoverName) as! ShoppingCartPopoverView
            
            return payPopoverView
        } else {
            let shoppingCartPayPopoverView = UIView.loadFromNibNamed(popoverName) as! ShoppingCartPayPopoverView
            
            return shoppingCartPayPopoverView
        }
    }
    
    func viewWillDisappear() {
        popoverName = ""
    }
    
    func viewHeight() -> CGFloat {
        return popoverName == "ShoppingCartPayPopoverView" ? 315 : 226
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            return indexPath.row == category.count ? leftTableView.bounds.height - CGFloat(category.count * 40) : 40
        } else {
            return 65
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == Constants.Tag.PartsMallLeftTableView ? category.count + 1 : titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            if indexPath.row != category.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("leftTableViewCell")
        
                let title = cell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
                title.text = category[indexPath.row]
        
                let seperator = cell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator)
            
                if indexPath.row == 0 {
                    title.textColor = Constants.Color.Primary
                    cell?.backgroundColor = UIColor.whiteColor()
                    seperator?.alpha = 0
                } else {
                    cell?.backgroundColor = Constants.Color.Gray
                    seperator?.alpha = 1
                }
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("leftTableViewFooter")
                cell?.backgroundColor = Constants.Color.Gray
            
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("rightTableViewCell")
            
            let titleLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightTitle) as! UILabel
            titleLabel.text = titles[indexPath.row]
            
            let priceLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightPrice) as! UILabel
            priceLabel.text = price[indexPath.row]
            priceLabel.textColor = Constants.Color.Orange
            
            let addButton = cell?.viewWithTag(Constants.Tag.PartsMallRightAdd) as! UIButton
            addButton.layer.cornerRadius = 20 / 2
            addButton.backgroundColor = Constants.Color.Primary
            addButton.addTarget(self, action: #selector(PartsMallViewController.add), forControlEvents: UIControlEvents.TouchUpInside)
            
            let reduceButton = cell?.viewWithTag(Constants.Tag.PartsMallRightReduce) as! UIButton
            reduceButton.layer.cornerRadius = 20 / 2
            reduceButton.layer.borderColor = Constants.Color.Gray.CGColor
            reduceButton.layer.borderWidth = 0.5
            //reduceButton.titleLabel?.textColor = Constants.Color.Primary
            
            return cell!
        }
    }
    
    func add() {
        print("add")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            let lastCell = tableView.cellForRowAtIndexPath(lastPick)
            let lastTitle = lastCell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
            lastTitle.textColor = UIColor.darkGrayColor()
            let lastSeperator = lastCell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator)
            lastCell?.backgroundColor = Constants.Color.Gray
            lastSeperator?.alpha = 1
            
            let currentCell = tableView.cellForRowAtIndexPath(indexPath)
            let currentTitle = currentCell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
            currentTitle.textColor = Constants.Color.Primary
            let currentSeperator = currentCell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator)
            currentCell?.backgroundColor = UIColor.whiteColor()
            currentSeperator?.alpha = 0
            
            lastPick = indexPath
        }
    }
}
