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
    @IBOutlet var picture3ImageView: UIImageView!
    @IBOutlet var picture4ImageView: UIImageView!
    
    @IBOutlet var maintenanceTypeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var feeImgImageView: UIImageView!
    @IBOutlet var feeTypeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var image1Height: NSLayoutConstraint!
    
    var order: Order?
    
    var delegate: GrabOrderDelegate?
    
    var images: [UIImageView] = []
    
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
        if order?.type == .Urgent {
            typeLabel.backgroundColor = Constants.Color.Orange
            typeLabel.text = "紧急"
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
        
        images.append(picture1ImageView)
        images.append(picture2ImageView)
        images.append(picture3ImageView)
        images.append(picture4ImageView)
        
        if order?.imageUrls!.count == 0 {
            image1Height.constant = 1
            picture1ImageView.hidden = true
            picture2ImageView.hidden = true
            picture3ImageView.hidden = true
            picture4ImageView.hidden = true
        } else {
            for index in 0...(order?.imageUrls!.count)!-1 {
                images[index].hnk_setImageFromURL(NSURL(string: (order?.imageUrls![index])!)!)
                images[index].clipsToBounds = true
                images[index].setupForImageViewer(Constants.Color.BlackBackground)
            }
        }
        
        maintenanceTypeLabel.text = (order?.mType)! + "维修"
        
        distanceLabel.text = "距离您\(order!.distance!)公里"
        
        timeLabel.text = UtilBox.getDateFromString(order!.date!, format: Constants.DateFormat.MDHm)
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let view =  BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "aaa")
        view.animatesDrop = true
        view.image = UIImage(named: "customerLocation")
        
        return view
    }
    
    @IBAction func grab(sender: UIButton) {
        if order?.type == .Urgent && !Config.canGrabUrgentOrder {
            UtilBox.alert(self, message: "你还有未完成的紧急订单")
        } else {
            self.pleaseWait()
            OrderModel(orderDelegate: self).grabOrder(order!)
        }
    }
    
    func onGrabOrderResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("抢单成功", autoClear: true, autoClearTime: 2)
            Config.NotToHomePage = true
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
            self.navigationController?.popViewControllerAnimated(true)
            delegate?.didGrabOrder()
        }
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
