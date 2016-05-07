//
//  ChooseLocationTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerPersonInfoLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, UserInfoDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var chooseCityButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var addressList = [BMKPoiInfo]()
    
    var cityName = ""
    
    var delegate: CustomerPersonInfoDelegate?
    
    let poiSearch = BMKPoiSearch()
    let locationService = BMKLocationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
        poiSearch.delegate = self
        //locationService.delegate = self
        //locationService.startUserLocationService()
    }
    
    func initView() {
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        searchBar.barTintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        searchBar.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        searchBar.tintColor = Constants.Color.Primary
        
        chooseCityButton.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        //        let localLatitude=userLocation.location.coordinate.latitude
        //        let localLongitude=userLocation.location.coordinate.longitude
        //
        //        let geocoder = CLGeocoder()
        //        geocoder.reverseGeocodeLocation(CLLocation(latitude: localLatitude, longitude: localLongitude)) { (place, error) in
        //            for placeMark in place! {
        //                let cityName = placeMark.locality
        //                print(cityName)
        //            }
        //        }
    }
    
    @IBAction func chooseCity(sender: UIButton) {
        let cityVC = CFCityPickerVC()
        
        //设置热门城市
        cityVC.hotCities = []
        
        let navVC = UINavigationController(rootViewController: cityVC)
        navVC.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.presentViewController(navVC, animated: true, completion: nil)
        
        //解析字典数据
        let cityModels = cityModelsPrepare()
        cityVC.cityModels = cityModels
        
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
            self.chooseCityButton.setTitle(cityModel.name, forState: UIControlState.Normal)
            self.chooseCityButton.setTitle(cityModel.name, forState: UIControlState.Highlighted)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cityName = (cell?.textLabel?.text)!
        
        UserInfoModel(userInfoDelegate: self).doModifyUserInfo(["key": "adr", "value": cityName])
        self.pleaseWait()
        
        delegate?.didChooseLocation((cell?.textLabel?.text)!, location: CLLocation())
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onModifyUserInfoResult(result: Bool, info: String) {
        if result {
            delegate?.didChooseLocation(cityName, location: CLLocation())
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
        
        self.clearAllNotice()
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("locationCell")! as UITableViewCell
        
        cell.textLabel?.text = addressList[indexPath.row].name
        cell.detailTextLabel?.text = addressList[indexPath.row].address
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let option = BMKCitySearchOption()
        option.city = chooseCityButton.currentTitle
        option.pageCapacity = 10
        option.keyword = searchText
        poiSearch.poiSearchInCity(option)
    }
    
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if poiResult == nil{
            return
        }
        
        let list = poiResult.poiInfoList
        
        if list == nil {
            addressList = []
        } else {
            addressList = list as! [BMKPoiInfo]
        }
        
        tableView.reloadData()
    }
    
}