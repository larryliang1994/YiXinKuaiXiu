//
//  ChooseFeeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/10.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit


class ChooseFeeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let fees = ["5", "10", "15", "20", "30"]
    var delegate: OrderPublishDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fees.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (UIScreen.mainScreen().bounds.width - 10) / 3;
        return CGSizeMake(width, 60);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectedFee(fees[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("chooseFeeCell", forIndexPath: indexPath)
        
        let button = cell.viewWithTag(Constants.Tag.CustomerChooseFeeCellButton) as! UIButton
        
        button.setTitle(fees[indexPath.row] + "元", forState: .Normal)
        button.layer.borderColor = Constants.Color.Primary.CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.enabled = false
        
        return cell
    }

}
