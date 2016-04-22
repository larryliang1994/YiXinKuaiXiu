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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        //descLabel.text = "      水管漏了"
        
        typeLabel.clipsToBounds = true
        typeLabel.layer.cornerRadius = 3
        typeLabel.backgroundColor = Constants.Color.Orange
        
        picture1ImageView.image = UIImage(named: "close")
        picture2ImageView.image = UIImage(named: "close")
        
        maintenanceTypeLabel.text = "水维修"
        
        distanceLabel.text = "距离您3公里"
        
        feeTypeLabel.text = "检修费"
        
        feeLabel.text = "¥20"
        feeLabel.textColor = Constants.Color.Orange
        
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
