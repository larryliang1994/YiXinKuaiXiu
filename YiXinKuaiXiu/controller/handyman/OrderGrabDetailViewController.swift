//
//  OrderGrabDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/18.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderGrabDetailViewController: UIViewController {

    @IBOutlet var mapView: BMKMapView!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var picture1ImageView: UIImageView!
    @IBOutlet var picture2ImageView: UIImageView!
    @IBOutlet var maintenanceTypeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var feeImgImageView: UIImageView!
    @IBOutlet var feeTypeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        descLabel.text = "        " + order!.desc!
        
        typeLabel.clipsToBounds = true
        typeLabel.layer.cornerRadius = 3
        if order?.type == .Normal {
            typeLabel.backgroundColor = Constants.Color.Orange
            typeLabel.text = "普通"
            feeTypeLabel.text = "检查费"
            feeLabel.textColor = Constants.Color.Orange
            feeLabel.text = "￥" + String(order!.fee!)
        } else if order?.type == .Pack {
            typeLabel.backgroundColor = Constants.Color.Primary
            typeLabel.text = "打包"
            feeTypeLabel.text = "打包费"
            feeLabel.textColor = Constants.Color.Orange
            feeLabel.text = "￥" + String(order!.fee!)
        } else {
            typeLabel.backgroundColor = Constants.Color.Blue
            typeLabel.text = "预约"
            feeTypeLabel.hidden = true
            feeLabel.hidden = true
            feeImgImageView.hidden = true
        }
        
        picture1ImageView.image = UIImage(named: "close")
        picture2ImageView.image = UIImage(named: "close")
        
        maintenanceTypeLabel.text = order?.mType
        
        distanceLabel.text = "距离您3公里"
        
        timeLabel.text = "3月29日 18:30"
        
        button.layer.cornerRadius = 3
        button.backgroundColor = Constants.Color.Primary
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        //mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        //mapView.delegate = nil // 不用时，置nil
    }
}
