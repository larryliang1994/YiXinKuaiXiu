//
//  OrderPublishViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderPublishViewController: UITableViewController {

    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var descTextView: BRPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "普通维修"
        
        descTextView.placeholder = "在这儿输入问题详情"
        descTextView.setPlaceholderFont(UIFont(name: (descTextView.font?.fontName)!, size: 16))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(OrderPublishViewController.choosePicture))
        picture1ImageView.addGestureRecognizer(tap)
        picture2ImageView.addGestureRecognizer(tap)
        
        initNavBar()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func choosePicture(){
        print("here")
        
        let pickerController = DKImagePickerController()
        //pickerController.defaultSelectedAssets = self.selecedPhotos
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 2
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            self.photos.removeAll()
//            
//            if assets.count != 0 {
//                for index in 0...assets.count-1 {
//                    self.photos.append(
//                        UtilBox.getAssetThumbnail(assets[index].originalAsset!))
//                }
//            }
//            
//            self.photos.append(UIImage(named: "add_picture")!)
//            
//            self.selecedPhotos = assets
//            
//            self.photoCollectionView.reloadData()
//            self.tableView.beginUpdates()
//            self.tableView.endUpdates()
            
        }
        
        self.presentViewController(pickerController, animated: true){}
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func publish(sender: UIBarButtonItem) {
        //UtilBox.alert(self, message: "发布")
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
                performSegueWithIdentifier(Constants.SegueID.EditPriceSegue, sender: self)
            } else if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.SegueID.ChooseMaintenanceTyeSegue, sender: self)
            } else if indexPath.row == 1 {
                performSegueWithIdentifier(Constants.SegueID.ChooseLocationSegue, sender: self)
            }
        }
    }
}
