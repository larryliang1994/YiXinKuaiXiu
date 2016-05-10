//
//  PartsMallViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PartsMallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopBottomViewDataSource,PopBottomViewDelegate, PartsMallDelegate {

    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomSeperator: UIView!
    @IBOutlet var leftTableView: UITableView!
    @IBOutlet var numBadge: SwiftBadge!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var rightTableView: UITableView!
    @IBOutlet var showShoppingCartButton: UIButton!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var bottomSeperatorHeight: NSLayoutConstraint!
    
    let category = [
        Category(id: 0, name: "金属配件", partIndex: 0),
        Category(id: 1, name: "塑料配件", partIndex: 4),
        Category(id: 2, name: "冷却剂", partIndex: 7),
        Category(id: 3, name: "油漆", partIndex: 12),
        Category(id: 4, name: "锁具", partIndex: 14),
        Category(id: 5, name: "其他", partIndex: 18)
    ]
    
    var parts = [
        Part(id: 0, name: "0十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 0),
        Part(id: 1, name: "0一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 0),
        Part(id: 2, name: "0一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 0),
        Part(id: 3, name: "0六角螺母2.5*3mm", num: 0, price: 0.5, categoryIndex: 0),
        
        Part(id: 4, name: "1十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 1),
        Part(id: 5, name: "1一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 1),
        Part(id: 6, name: "1一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 1),
        
        Part(id: 7, name: "2十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 2),
        Part(id: 8, name: "2一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 2),
        Part(id: 9, name: "2一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 2),
        Part(id: 10, name: "2六角螺母2.5*3mm", num: 0, price: 0.5, categoryIndex: 2),
        Part(id: 11, name: "2六角螺母2.5*3mm", num: 0, price: 0.5, categoryIndex: 2),
        
        Part(id: 12, name: "3十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 3),
        Part(id: 13, name: "3一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 3),
        
        Part(id: 14, name: "4十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 4),
        Part(id: 15, name: "4一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 4),
        Part(id: 16, name: "4一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 4),
        Part(id: 17, name: "4六角螺母2.5*3mm", num: 0, price: 0.5, categoryIndex: 4),
        
        Part(id: 18, name: "5十字钉2.5*3mm", num: 0, price: 0.5, categoryIndex: 5),
        Part(id: 19, name: "5一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 5),
        Part(id: 20, name: "5一字钉3*12mm", num: 0, price: 0.5, categoryIndex: 5)
    ]

    var totalNum = 0
    var totalPrice: Float = 0.0
    var categoryIndex = 0
    
    var popoverName = ""
    
    var lastPick = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        updateBottonView()
        
        rightTableView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func initView() {
        payButton.layer.cornerRadius = 3
        payButton.backgroundColor = Constants.Color.Orange
        
        numBadge.badgeColor = Constants.Color.Orange
        numBadge.hidden = true
        
        leftTableView.tableHeaderView = nil
        leftTableView.backgroundColor = Constants.Color.Gray
        
        rightTableView.tableHeaderView = nil
        rightTableView.tableFooterView = UIView()
        rightTableView.backgroundColor = UIColor.whiteColor()
        
        bottomSeperatorHeight.constant = 0.5
        
        self.view.setNeedsLayout()
    }
    
    func didChangeData(num: Int, price: Float) {
        totalNum += num
        totalPrice += price
        
        updateBottonView()
    }
    
    func didClear() {
        hide(containerView)
        
        for var part in parts {
            part.num = 0
        }
        
        rightTableView.reloadData()
        
        totalNum = 0
        totalPrice = 0
        
        updateBottonView()
    }
    
    // 更新底部栏的状态
    func updateBottonView() {
        if totalNum == 0 {
            showShoppingCartButton.enabled = false
            showShoppingCartButton.setImage(UIImage(named: "shoppingCartEmpty"), forState: .Normal)
            
            payButton.enabled = false
            payButton.backgroundColor = UIColor.grayColor()
            numBadge.hidden = true
            
            totalPriceLabel.font = UIFont(name: (totalPriceLabel?.font?.fontName)!, size: 15)
            totalPriceLabel.text = "购物车是空的"
            totalPriceLabel.textColor = UIColor.grayColor()
        } else {
            showShoppingCartButton.enabled = true
            showShoppingCartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
            
            payButton.enabled = true
            payButton.backgroundColor = Constants.Color.Orange
            numBadge.hidden = false
            numBadge.text = totalNum.toString()
            
            totalPriceLabel.font = UIFont(name: (totalPriceLabel?.font?.fontName)!, size: 17)
            totalPriceLabel.text = "￥" + String(totalPrice)
            totalPriceLabel.textColor = Constants.Color.Primary
        }
    }

    func hide(container: UIView){
        for v in container.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    @IBAction func showShoppingCart(sender: UIButton) {
        if popoverName == "" {
            let v = PopBottomView(frame: containerView.bounds)
            popoverName = "ShoppingCartPopoverView"
            v.dataSource = self
            v.delegate = self
            v.showInView(containerView)
        } else {
            hide(containerView)
        }
    }
    
    // 点击结算
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
            let shoppingCartPopoverView = UIView.loadFromNibNamed(popoverName) as! ShoppingCartPopoverView
            
            shoppingCartPopoverView.parts = parts
            shoppingCartPopoverView.delegate = self
            
            return shoppingCartPopoverView
        } else {
            let shoppingCartPayPopoverView = UIView.loadFromNibNamed(popoverName) as! ShoppingCartPayPopoverView
            
            shoppingCartPayPopoverView.closeButton.addTarget(self, action: #selector(PartsMallViewController.close), forControlEvents: .TouchUpInside)
            shoppingCartPayPopoverView.doPayButton.addTarget(self, action: #selector(PartsMallViewController.goPay), forControlEvents: .TouchUpInside)
            shoppingCartPayPopoverView.priceLabel.text = "￥" + String(totalPrice)
            
            var desc = ""
            for var part in parts {
                if part.num != 0 {
                    desc += part.name! + " x " + (part.num?.toString())! + "; "
                }
            }
            shoppingCartPayPopoverView.descLabel.text = desc
            
            return shoppingCartPayPopoverView
        }
    }
    
    func close() {
        hide(self.view)
    }
    
    func goPay() {
        //hide(self.view)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func viewWillDisappear() {
        popoverName = ""
        rightTableView.reloadData()
    }
    
    func viewHeight() -> CGFloat {
        return popoverName == "ShoppingCartPayPopoverView" ? 357 : 226
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            return indexPath.row == category.count ? leftTableView.bounds.height - CGFloat(category.count * 40) + 1: 40
        } else {
            return 65
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == Constants.Tag.PartsMallLeftTableView ? category.count + 1 : parts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            if indexPath.row != category.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("leftTableViewCell")
        
                let title = cell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
                title.text = category[indexPath.row].name
        
                let seperator = cell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator) as UIView!
                
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
            titleLabel.text = parts[indexPath.row].name
            
            let priceLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightPrice) as! UILabel
            priceLabel.text = "￥" + String(parts[indexPath.row].price!)
            priceLabel.textColor = Constants.Color.Orange
            
            let addButton = cell?.viewWithTag(Constants.Tag.PartsMallRightAdd) as! UIButton
            addButton.layer.cornerRadius = 20 / 2
            addButton.backgroundColor = Constants.Color.Primary
            addButton.addTarget(self, action: #selector(PartsMallViewController.add), forControlEvents: UIControlEvents.TouchUpInside)
            
            let reduceButton = cell?.viewWithTag(Constants.Tag.PartsMallRightReduce) as! UIButton
            reduceButton.layer.cornerRadius = 20 / 2
            reduceButton.layer.borderColor = Constants.Color.Gray.CGColor
            reduceButton.layer.borderWidth = 0.5
            reduceButton.addTarget(self, action: #selector(PartsMallViewController.reduce), forControlEvents: UIControlEvents.TouchUpInside)
            
            let num = parts[indexPath.row].num
            let numLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightNum) as! UILabel
            
            if num == 0 {
                reduceButton.hidden = true
                numLabel.hidden = true
            } else {
                reduceButton.hidden = false
                numLabel.hidden = false
                numLabel.text = parts[indexPath.row].num!.toString()
            }
            
            return cell!
        }
    }
    
    func add(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = rightTableView.indexPathForCell(cell)!
        
        if parts[indexPath.row].num != 99 {
            parts[indexPath.row].num! += 1
            
            rightTableView.reloadData()
            
            totalNum += 1
            
            totalPrice += Float(parts[indexPath.row].price!)
            
            updateBottonView()
        }
    }
    
    func reduce(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = rightTableView.indexPathForCell(cell)!
        
        if parts[indexPath.row].num != 0 {
            parts[indexPath.row].num! -= 1
        
            rightTableView.reloadData()
            
            totalNum -= 1
            
            totalPrice -= Float(parts[indexPath.row].price!)
            
            updateBottonView()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "leftTableViewFooter" {
            return
        }
        
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            
            updateLeftTableView(indexPath)
            
            if categoryIndex != indexPath.row {
                categoryIndex = indexPath.row
            
                let index = NSIndexPath(forRow: category[categoryIndex].partIndex!, inSection: 0)
            
                rightTableView.selectRowAtIndexPath(index, animated: false, scrollPosition: .Top)
            }
        }
    }
    
    // 选取最后一个的时候会有问题
    func updateLeftTableView(indexPath: NSIndexPath) {
        let lastCell = leftTableView.cellForRowAtIndexPath(lastPick)
        let lastTitle = lastCell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
        lastTitle.textColor = UIColor.darkGrayColor()
        let lastSeperator = lastCell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator)
        lastCell?.backgroundColor = Constants.Color.Gray
        lastSeperator?.alpha = 1
        
        let currentCell = leftTableView.cellForRowAtIndexPath(indexPath)
        let currentTitle = currentCell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
        currentTitle.textColor = Constants.Color.Primary
        let currentSeperator = currentCell?.viewWithTag(Constants.Tag.PartsMallLeftCellSeperator)
        currentCell?.backgroundColor = UIColor.whiteColor()
        currentSeperator?.alpha = 0
        
        lastPick = indexPath
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView {
            if tableView.tag == Constants.Tag.PartsMallRightTableView {
                let row = rightTableView.indexPathForCell(tableView.visibleCells[0])?.row
                let cIndex = parts[row!].categoryIndex
                
                if cIndex != categoryIndex {
                    categoryIndex = row!
                    
                    let index = NSIndexPath(forRow: cIndex!, inSection: 0)
                    
                    updateLeftTableView(index)
                    
                    leftTableView.selectRowAtIndexPath(index, animated: true, scrollPosition: .Top)
                }
            }
        }
    }
}

protocol PartsMallDelegate {
    func didChangeData(num: Int, price: Float)
    func didClear()
}
