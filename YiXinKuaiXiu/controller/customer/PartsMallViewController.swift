//
//  PartsMallViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftyJSON

class PartsMallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopBottomViewDataSource,PopBottomViewDelegate, PartsMallDelegate, GetPartsInfoDelegate, PopoverPayDelegate, PartsMallSearchDelegate {

    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomSeperator: UIView!
    @IBOutlet var leftTableView: UITableView!
    @IBOutlet var numBadge: SwiftBadge!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var rightTableView: UITableView!
    @IBOutlet var showShoppingCartButton: UIButton!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var bottomSeperatorHeight: NSLayoutConstraint!
    
    var totalNum = 0
    var totalPrice: Float = 0.0
    var categoryIndex = 0
    
    var popoverName = ""
    
    var order: Order?
    
    var delegate: OrderListChangeDelegate?
    
    var lastPick = NSIndexPath(forRow: 0, inSection: 0)
    
    var needScroll = false
    var scrollID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        updateBottonView()
        
        rightTableView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        GetPartsInfoModel(getPartsInfoDelegate: self).doGetPartsInfo()
        
        rightTableView.estimatedRowHeight = rightTableView.rowHeight
        rightTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if needScroll {
            for var index in 0...Config.Parts.count-1 {
                if Config.Parts[index].id == scrollID {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    rightTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
                    
                    // 这里会报错，暂时不知道为什么，所以先注释掉
//                    if Config.Parts[indexPath.row].num != 99 {
//                        Config.Parts[indexPath.row].num! += 1
//                        
//                        rightTableView.reloadData()
//
//                        totalNum += 1
//                        
//                        totalPrice += Float(Config.Parts[indexPath.row].price!)
//                        
//                        updateBottonView()
//                    }
                    
                    needScroll = false
                    scrollID = nil
                }
            }
        }
    }
    
    func initView() {
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
    
    func onGetPartsInfoResult(result: Bool, info: String) {
        if result {
            GetPartsInfoModel(getPartsInfoDelegate: self).doGetCategoryInfo()
        }
    }
    
    func onGetCategoryInfoResult(result: Bool, info: String) {
        if result {
            initCPIndex()
            
            leftTableView.reloadData()
            rightTableView.reloadData()
        }
    }
    
    func initCPIndex() {
        // 初始化类别的Index
        for var category in Config.Categorys {
            for var index in 0...Config.Parts.count {
                if Config.Parts[index].categoryID == category.id {
                    category.partIndex = index
                    break
                }
            }
        }
        
        // 初始化配件的Index
        for var part in Config.Parts {
            for var index in 0...Config.Categorys.count {
                if part.categoryID == Config.Categorys[index].id {
                    part.categoryIndex = index
                    break
                }
            }
        }
    }
    
    func didChangeData(num: Int, price: Float) {
        totalNum += num
        totalPrice += price
        
        updateBottonView()
    }
    
    func didClear() {
        hide(containerView)
        
        for var part in Config.Parts {
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
            payButton.backgroundColor = UIColor.lightGrayColor()
            numBadge.hidden = true
            
            totalPriceLabel.font = UIFont(name: (totalPriceLabel?.font?.fontName)!, size: 15)
            totalPriceLabel.text = "购物车是空的"
            totalPriceLabel.textColor = UIColor.grayColor()
        } else {
            showShoppingCartButton.enabled = true
            showShoppingCartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
            
            payButton.enabled = true
            payButton.backgroundColor = Constants.Color.Primary
            numBadge.hidden = false
            numBadge.text = totalNum.toString()
            
            totalPriceLabel.font = UIFont(name: (totalPriceLabel?.font?.fontName)!, size: 17)
            totalPriceLabel.text = "￥" + String(totalPrice)
            totalPriceLabel.textColor = Constants.Color.Primary
        }
    }
    
    @IBAction func showSearchBar(sender: UIBarButtonItem) {
        let searchVC = UtilBox.getController(Constants.ControllerID.PartsMallSearch) as! PartsMallSearchViewController
        searchVC.delegate = self
        self.navigationController?.showViewController(searchVC, sender: self)
    }
    
    func didSelect(id: Int) {
        needScroll = true
        scrollID = id
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
            
            shoppingCartPopoverView.parts = Config.Parts
            shoppingCartPopoverView.delegate = self
            
            return shoppingCartPopoverView
        } else {
            let shoppingCartPayPopoverView = UIView.loadFromNibNamed(popoverName) as! ShoppingCartPayPopoverView
            
            shoppingCartPayPopoverView.closeButton.addTarget(self, action: #selector(PartsMallViewController.close), forControlEvents: .TouchUpInside)
            shoppingCartPayPopoverView.doPayButton.addTarget(self, action: #selector(PartsMallViewController.close), forControlEvents: .TouchUpInside)
            shoppingCartPayPopoverView.priceLabel.text = "￥" + String(totalPrice)
            shoppingCartPayPopoverView.date = order!.date!
            shoppingCartPayPopoverView.detail = generatePartsDetail()
            shoppingCartPayPopoverView.fee = String(totalPrice)
            shoppingCartPayPopoverView.delegate = self
            shoppingCartPayPopoverView.viewController = self
            
            var desc = ""
            for var part in Config.Parts {
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
    
    func generatePartsDetail() -> String {
        var jsonDic: [String: [JSON]] = ["val": []]
        
        // 原本已购买的
        var index = 0
        for var part in order!.parts! {
            if part.num != 0 {
                jsonDic["val"]?.append(JSON(["nme": part.name!, "prs": part.price!, "num": part.num!]))
                
                index += 1
            }
        }
        
        // 后来添加的
        index = 0
        for var part in Config.Parts {
            if part.num != 0 {
                jsonDic["val"]?.append(JSON(["nme": part.name!, "prs": part.price!, "num": part.num!]))
                
                index += 1
            }
        }
        
        var detailString = jsonDic.description
            .stringByReplacingOccurrencesOfString("\n", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        detailString = detailString.substringToIndex(detailString.endIndex.predecessor()).substringFromIndex(detailString.startIndex.advancedBy(1))
        
        return "{" + detailString + "}"
    }
    
    func onPayResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            delegate?.didChange()
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        popoverName = ""
        rightTableView.reloadData()
    }
    
    func viewHeight() -> CGFloat {
        return popoverName == "ShoppingCartPayPopoverView" ? 408 : 226
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
            return indexPath.row == Config.Categorys.count ? leftTableView.bounds.height - CGFloat(Config.Categorys.count * 40) + 1: 40
        } else {
            if Config.Parts[indexPath.row].desc == "" || Config.Parts[indexPath.row].desc == "无" {
                return 65
            } else {
                return UITableViewAutomaticDimension
            }
            
//            return UITableViewAutomaticDimension
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == Constants.Tag.PartsMallLeftTableView ? Config.Categorys.count + 1 : Config.Parts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            if indexPath.row != Config.Categorys.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("leftTableViewCell")
        
                let title = cell?.viewWithTag(Constants.Tag.PartsMallLeftCellLabel) as! UILabel
                title.text = Config.Categorys[indexPath.row].name
        
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
            titleLabel.text = Config.Parts[indexPath.row].name
            
            let priceLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightPrice) as! UILabel
            priceLabel.text = "￥" + String(Config.Parts[indexPath.row].price!)
            priceLabel.textColor = Constants.Color.Orange
            
            let descLabel = cell?.viewWithTag(1) as! UILabel
            descLabel.text = Config.Parts[indexPath.row].desc
            
            if Config.Parts[indexPath.row].desc == "" || Config.Parts[indexPath.row].desc == "无" {
                descLabel.font = UIFont(name: (descLabel.font?.familyName)!, size: 0)
            } else {
                descLabel.font = UIFont(name: (descLabel.font?.familyName)!, size: 11)
            }
            
            let addButton = cell?.viewWithTag(Constants.Tag.PartsMallRightAdd) as! UIButton
            addButton.layer.cornerRadius = 22 / 2
            addButton.backgroundColor = Constants.Color.Primary
            addButton.addTarget(self, action: #selector(PartsMallViewController.add), forControlEvents: UIControlEvents.TouchUpInside)
            
            let reduceButton = cell?.viewWithTag(Constants.Tag.PartsMallRightReduce) as! UIButton
            reduceButton.layer.cornerRadius = 22 / 2
            reduceButton.layer.borderColor = UIColor.grayColor().CGColor
            reduceButton.layer.borderWidth = 0.5
            reduceButton.addTarget(self, action: #selector(PartsMallViewController.reduce), forControlEvents: UIControlEvents.TouchUpInside)
            
            let num = Config.Parts[indexPath.row].num
            let numLabel = cell?.viewWithTag(Constants.Tag.PartsMallRightNum) as! UILabel
            
            if num == 0 {
                reduceButton.hidden = true
                numLabel.hidden = true
            } else {
                reduceButton.hidden = false
                numLabel.hidden = false
                numLabel.text = Config.Parts[indexPath.row].num!.toString()
            }
            
            return cell!
        }
    }
    
    func add(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = rightTableView.indexPathForCell(cell)!
        
        if Config.Parts[indexPath.row].num != 99 {
            Config.Parts[indexPath.row].num! += 1
            
            rightTableView.reloadData()
            
            totalNum += 1
            
            totalPrice += Float(Config.Parts[indexPath.row].price!)
            
            updateBottonView()
        }
    }
    
    func reduce(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = rightTableView.indexPathForCell(cell)!
        
        if Config.Parts[indexPath.row].num != 0 {
            Config.Parts[indexPath.row].num! -= 1
        
            rightTableView.reloadData()
            
            totalNum -= 1
            
            totalPrice -= Config.Parts[indexPath.row].price!
            
            updateBottonView()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "leftTableViewFooter" {
            return
        }
        
        if tableView.tag == Constants.Tag.PartsMallLeftTableView {
            
            if categoryIndex != indexPath.row {
                rightTableView.delegate = nil
                
                updateLeftTableView(indexPath)
                
                categoryIndex = indexPath.row
            
                let index = NSIndexPath(forRow: Config.Categorys[categoryIndex].partIndex!, inSection: 0)
            
                rightTableView.selectRowAtIndexPath(index, animated: false, scrollPosition: .Top)
                
                rightTableView.delegate = self
            }
        }
    }
    
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
                let cIndex = Config.Parts[row!].categoryIndex
                
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
