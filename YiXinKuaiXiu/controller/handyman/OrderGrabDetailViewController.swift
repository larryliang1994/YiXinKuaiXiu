//
//  OrderGrabDetailViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/18.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Haneke

class OrderGrabDetailViewController: UIViewController, OrderDelegate, BMKMapViewDelegate {

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
    @IBOutlet var image1Height: NSLayoutConstraint!
    
    var order: Order?
    
    var delegate: GrabOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        let annotation = BMKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (order?.locationInfo?.coordinate.latitude)!, longitude: (order?.locationInfo?.coordinate.longitude)!)
        annotation.title = order?.location
        
        mapView.delegate = self
        mapView.addAnnotation(annotation)
        mapView.showsUserLocation = true
        mapView.centerCoordinate = annotation.coordinate
        mapView.zoomLevel = 18
        
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
            typeLabel.backgroundColor = Constants.Color.Green
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
        
        if order?.image1Url != nil {
            picture1ImageView.hnk_setImageFromURL(NSURL(string: (order?.image1Url)!)!)
        } else {
            image1Height.constant = 1
            picture1ImageView.hidden = true
            picture2ImageView.hidden = true
        }
        if order?.image2Url != nil {
            picture2ImageView.hnk_setImageFromURL(NSURL(string: (order?.image2Url)!)!)
        }
        
        maintenanceTypeLabel.text = (order?.mType)! + "维修"
        
        distanceLabel.text = "距离您\(order!.distance!)公里"
        
        timeLabel.text = UtilBox.getDateFromString(order!.date!, format: Constants.DateFormat.MDHm)
    }
    
    @IBAction func doTapImg1(sender: UITapGestureRecognizer) {
        UtilBox.showBigImg(picture1ImageView, parent: self, imgUrl: (order?.image1Url)!)
    }
    
    @IBAction func doTapImg2(sender: UITapGestureRecognizer) {
        UtilBox.showBigImg(picture2ImageView, parent: self, imgUrl: (order?.image2Url)!)
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let view =  BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "aaa")
        view.animatesDrop = true
        view.image = UIImage(named: "customerLocation")
        
        return view
    }
    
    @IBAction func grab(sender: UIButton) {
        self.pleaseWait()
        OrderModel(orderDelegate: self).grabOrder(order!)
    }
    
    func onGrabOrderResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("抢单成功", autoClear: true, autoClearTime: 2)
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
        delegate?.didGrabOrder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil // 不用时，置nil
    }
    
    func onPublishOrderResult(result: Bool, info: String) {}
    
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order]) {}
    
    func onCancelOrderResult(result: Bool, info: String) {}
    
    func onCancelOrderConfirmResult(result: Bool, info: String) {}
}

protocol GrabOrderDelegate{
    func didGrabOrder()
}
