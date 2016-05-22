//
//  AuditIDViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class AuditIDViewController: UITableViewController, ChooseMTypeDelegete, ChooseLocationDelegate, AuditDelegate, UploadImageDelegate {
    
    @IBOutlet var maintenanceTypeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var submitButton: UIBarButtonItem!
    @IBOutlet var idNumTextField: UITextField!
    @IBOutlet var contactNameTextField: UITextField!
    @IBOutlet var contactTelephoneTextField: UITextField!
    @IBOutlet var pictureImageView: UIImageView!
    
    var checked: [Bool] = []
    
    var imageAsset: DKAsset?
    
    var locationInfo: CLLocation?
    
    var idString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        
        initView()
    }
    
    func initView() {
        //submitButton.enabled = false
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    @IBAction func submit(sender: UIBarButtonItem) {
        if maintenanceTypeLabel.text == "请选择" {
            UtilBox.alert(self, message: "请选择维修工种")
        } else if locationLabel.text == "选择地址" {
            UtilBox.alert(self, message: "请选择常住地址")
        } else if idNumTextField.text == nil || idNumTextField.text == "" {
            UtilBox.alert(self, message: "请输入身份证号码")
        } else if imageAsset == nil {
            UtilBox.alert(self, message: "请选择手持身份证照")
        } else if contactNameTextField.text == nil || contactNameTextField.text == "" {
            UtilBox.alert(self, message: "请输入紧急联系人姓名")
        } else if contactTelephoneTextField.text == nil || contactTelephoneTextField.text == "" {
            UtilBox.alert(self, message: "请输入紧急联系人手机号")
        } else {
            self.pleaseWait()
            
            UploadImageModel(uploadImageDelegate: self).uploadOrderImage(UtilBox.getAssetThumbnail(imageAsset!.originalAsset!))
        }
    }
    
    func onUploadOrderImageResult(result: Bool, info: String) {
        if result {
            AuditModel(auditDelegate: self).doAudit(idString!, location: locationLabel.text!, locationInfo: locationInfo!, IDNum: idNumTextField.text!, picture: "", contactsName: contactNameTextField.text!, contactNum: contactTelephoneTextField.text!)
        } else {
            self.clearAllNotice()
            UtilBox.alert(self, message: info)
        }
    }
    
    func onAuditResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("申请成功", autoClear: true, autoClearTime: 2)
            
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    @IBAction func choosePicture(sender: UITapGestureRecognizer){
        self.view.resignFirstResponder()
        
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
            
            if assets.count == 0 {
                self.imageAsset = nil
                self.pictureImageView.image = UIImage(named: "add_picture")
            } else {
                self.imageAsset = assets[0]
                self.pictureImageView.image = UtilBox.getAssetThumbnail(self.imageAsset!.originalAsset!)
            }
            
        }
        self.presentViewController(pickerController, animated: true){}
    }
    
    func fromAlbum() {
        let pickerController = DKImagePickerController()
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 1
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count == 0 {
                self.imageAsset = nil
                self.pictureImageView.image = UIImage(named: "add_picture")
            } else {
                self.imageAsset = assets[0]
                self.pictureImageView.image = UtilBox.getAssetThumbnail(self.imageAsset!.originalAsset!)
            }
        }
        
        self.presentViewController(pickerController, animated: true){}
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier(Constants.SegueID.ShowHandymanChooseMaintenanceTypeSegue, sender: self)
        } else if indexPath.row == 1 {
            let chooseLocationVC = UtilBox.getController(Constants.ControllerID.ChooseLocation) as! ChooseLocationTableViewController
            chooseLocationVC.delegate = self
            self.navigationController?.showViewController(chooseLocationVC, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let cmtvc = destination as? ChooseMaintenanceTypeViewController {
            cmtvc.delegate = self
            if self.checked.count != 0 {
                cmtvc.checked = self.checked
            }
        }
    }
    
    func didSelectedMaintenanceType(nameString: String, idString: String, checked: [Bool]) {
        if nameString != "" {
            maintenanceTypeLabel.text = nameString
            self.checked = checked
            self.idString = idString
        } else {
            maintenanceTypeLabel.text = "请选择"
        }
    }
    
    func didChooseLocation(name: String, locationInfo: CLLocation) {
        locationLabel.text = name
        self.locationInfo = locationInfo
    }
}
