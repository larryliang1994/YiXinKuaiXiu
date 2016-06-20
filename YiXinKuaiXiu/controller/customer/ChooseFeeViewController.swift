//
//  ChooseFeeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/10.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit


class ChooseFeeViewController: UIViewController, UICollectionViewDelegateFlowLayout, GetInitialInfoDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var feeTextField: UITextField!
    var delegate: OrderPublishDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
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
    
    @IBAction func done(sender: UIBarButtonItem) {
        if feeTextField.text == nil || feeTextField.text == "" {
            UtilBox.alert(self, message: "请输入检查费用")
            return
        }
        
        delegate?.didSelectedFee(feeTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Config.Fees.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (UIScreen.mainScreen().bounds.width - 20) / 3
        return CGSizeMake(width, 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectedFee(Config.Fees[indexPath.row].toString())
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("chooseFeeCell", forIndexPath: indexPath)
        
        let button = cell.viewWithTag(Constants.Tag.CustomerChooseFeeCellButton) as! HollowButton
        
        button.setTitle(Config.Fees[indexPath.row].toString() + "元", forState: .Normal)
        button.enabled = false
        
        return cell
    }

}
