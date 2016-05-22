//
//  ChooseFeeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/10.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit


class ChooseFeeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GetInitialInfoDelegate {
    
    var delegate: OrderPublishDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        if Config.Fees == [] {
            self.pleaseWait()
            GetInitialInfoModel(getInitialInfoDelegate: self).getFees()
        }
    }
    
    func onGetFeeResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            collectionView?.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Config.Fees.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (UIScreen.mainScreen().bounds.width - 10) / 3
        return CGSizeMake(width, 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectedFee(Config.Fees[indexPath.row].toString())
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("chooseFeeCell", forIndexPath: indexPath)
        
        let button = cell.viewWithTag(Constants.Tag.CustomerChooseFeeCellButton) as! HollowButton
        
        button.setTitle(Config.Fees[indexPath.row].toString() + "元", forState: .Normal)
        button.enabled = false
        
        return cell
    }

}
