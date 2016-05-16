//
//  OrderPublishViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Photos

class OrderPublishViewController: UITableViewController, UITextViewDelegate, OrderPublishDelegate, UploadImageDelegate,OrderDelegate, ChooseLocationDelegate {
    @IBOutlet var publishButtonItem: UIBarButtonItem!
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    
    @IBOutlet var descTextView: BRPlaceholderTextView!
    @IBOutlet var feeCell: UITableViewCell!
    
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var maintenanceTypeLabel: UILabel!
    
    var selectedImage: [DKAsset] = []
    var mTypeID: String?
    var locationInfo: CLLocation?
    
    var order: Order?
    var fee: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if title == Constants.Types[1] {
            feeCell.textLabel?.text = "打包费"
        } else if title == Constants.Types[2] {
            feeCell.hidden = true
        }
        
        initView()
        
        initNavBar()
    }
    
    func initView() {
        descTextView.placeholder = "在这儿输入问题详情"
        descTextView.setPlaceholderFont(UIFont(name: (descTextView.font?.fontName)!, size: 16))
        
        publishButtonItem.enabled = false
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func choosePicture(sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "拍照",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.fromCamera()
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "从相册中选择",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            self.fromAlbum()
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func fromCamera() {
        let pickerController = DKImagePickerController()
        pickerController.sourceType = .Camera
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.selectedImage = assets
            
            if self.selectedImage.count == 0 {
                self.picture1ImageView.image = UIImage(named: "add_picture")
                self.picture2ImageView.image = nil
            } else if self.selectedImage.count == 1 {
                self.picture1ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.picture2ImageView.image = UIImage(named: "add_picture")
                
            } else {
                self.picture1ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.picture2ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[1].originalAsset!)
            }
        }
        self.presentViewController(pickerController, animated: true){}
    }
    
    func fromAlbum() {
        let pickerController = DKImagePickerController()
        pickerController.defaultSelectedAssets = self.selectedImage
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 2
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.selectedImage = assets
            
            if self.selectedImage.count == 0 {
                self.picture1ImageView.image = UIImage(named: "add_picture")
                self.picture2ImageView.image = nil
            } else if self.selectedImage.count == 1 {
                self.picture1ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.picture2ImageView.image = UIImage(named: "add_picture")
                
            } else {
                self.picture1ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[0].originalAsset!)
                self.picture2ImageView.image = UtilBox.getAssetThumbnail(self.selectedImage[1].originalAsset!)
            }
        }
        
        self.presentViewController(pickerController, animated: true){}
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    // 生成订单
    func generateOrder() {
        var image1: DKAsset?, image2: DKAsset?
        if selectedImage.count == 0 {
            image1 = nil
            image2 = nil
        } else if selectedImage.count == 1 {
            image1 = selectedImage[0]
            image2 = nil
        } else {
            image1 = selectedImage[0]
            image2 = selectedImage[1]
        }
        
        var type: Type
        if self.title == Constants.Types[0] {
            type = .Normal
        } else if self.title == Constants.Types[1] {
            type = .Pack
        } else {
            type = .Reservation
        }
        order = Order(type: type, desc: descTextView.text, mType: maintenanceTypeLabel.text!, mTypeID: mTypeID!, location: locationLabel.text!, locationInfo: locationInfo!, fee: self.fee, image1: image1, image2: image2)
    }
    
    @IBAction func publish(sender: UIBarButtonItem) {
        descTextView.resignFirstResponder()
        
        generateOrder()
        
        OrderModel(orderDelegate: self).publishOrder(order!)
        
        
//        if order?.image1 != nil {
//            UploadImageModel(uploadImageDelegate: self).uploadOrderImage(UtilBox.getAssetThumbnail((order?.image1?.originalAsset)!))
//        } else {
//            OrderModel(orderDelegate: self).publishOrder(order!)
//        }
        
        self.pleaseWait()
    }
    
    var uploadedCount = 0
    func onUploadOrderImageResult(result: Bool, info: String) {
        if result {
            uploadedCount += 1;
            
            if order?.image2 != nil && uploadedCount != 2 {
                UploadImageModel(uploadImageDelegate: self).uploadOrderImage(UtilBox.getAssetThumbnail((order?.image2?.originalAsset)!))
            } else {
                OrderModel(orderDelegate: self).publishOrder(order!)
            }
        } else {
            UtilBox.alert(self, message: info)
            self.clearAllNotice()
        }
    }
    
    func onPublishOrderResult(result: Bool, info: String) {
        if result {
            order?.date = info
            if order?.type == .Reservation {
                self.noticeSuccess("发布成功", autoClear: true, autoClearTime: 2)
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                performSegueWithIdentifier(Constants.SegueID.ShowOrderPublishConfirmSegue, sender: self)
            }
        } else {
            UtilBox.alert(self, message: info)
        }
        
        self.clearAllNotice()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                if title == Constants.Types[0] {
                    performSegueWithIdentifier(Constants.SegueID.ChooseFeeSegue, sender: self)
                } else {
                    performSegueWithIdentifier(Constants.SegueID.EditPriceSegue, sender: self)
                }
            } else if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.SegueID.ChooseMaintenanceTyeSegue, sender: self)
            } else if indexPath.row == 1 {
                let chooseLocationVC = UtilBox.getController(Constants.ControllerID.ChooseLocation) as! ChooseLocationTableViewController
                chooseLocationVC.delegate = self
                self.navigationController?.showViewController(chooseLocationVC, sender: self)
            }
            
            descTextView.resignFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let mtvc = destination as? MaintenanceTypeViewController {
            mtvc.delegate = self
        } else if let cfvc = destination as? CheckFeeViewController {
            cfvc.delegate = self
        } else if let opcvc = destination as? OrderPublishConfirmViewController {
            opcvc.order = order
        } else if let cfvc = destination as? ChooseFeeViewController {
            cfvc.delegate = self
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text?.characters.count != 0 && maintenanceTypeLabel.text != "点击选择" && locationLabel.text != "点击选择" {
            if title != Constants.Types[2] && feeLabel.text == "点击选择" {
                return
            }
            publishButtonItem.enabled = true
        } else {
            publishButtonItem.enabled = false
        }
    }
    
    func didSelectedMaintenanceType(type: String, id: String) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        cell?.detailTextLabel?.text = type + "维修"
        
        mTypeID = id
        
        if locationLabel.text != "点击选择" && descTextView.text != nil {
            if title != Constants.Types[2] && feeLabel.text == "点击选择" {
                return
            }
            publishButtonItem.enabled = true
        }
    }
    
    func didChooseLocation(name: String, locationInfo: CLLocation) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
        cell?.detailTextLabel?.text = name
        self.locationInfo = locationInfo
        
        if maintenanceTypeLabel.text != "点击选择" && descTextView.text != nil {
            if title != Constants.Types[2] && feeLabel.text == "点击选择" {
                return
            }
            publishButtonItem.enabled = true
        }
    }
    
    func didSelectedFee(fee: String) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
        cell?.detailTextLabel?.text = "￥ " + fee
        
        self.fee = fee
        
        if maintenanceTypeLabel.text != "点击选择" && locationLabel.text != "点击选择" && descTextView.text != nil {
            publishButtonItem.enabled = true
        }
    }
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onGrabOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
}

protocol OrderPublishDelegate {
    func didSelectedMaintenanceType(type: String, id: String)
    func didSelectedFee(fee: String)
}
