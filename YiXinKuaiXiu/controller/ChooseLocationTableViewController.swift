//
//  ChooseLocationTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import UsefulPickerView

class ChooseLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, GetInitialInfoDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var chooseCityButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var addressList = [BMKPoiInfo]()
    
    var delegate: ChooseLocationDelegate?
    
    var cityList: [String] = []
    var cityIndex = 0
    
    let poiSearch = BMKPoiSearch()
    let locationService = BMKLocationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
        poiSearch.delegate = self
        
        locationService.delegate = self
        
        self.pleaseWait()
        
        GetInitialInfoModel(getInitialInfoDelegate: self).getCityList()
        
        if Config.CurrentLocationInfo != nil {
            showDefaultLocationList(Config.CurrentLocationInfo!.coordinate)
        }
    }
    
    func initView() {
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        searchBar.barTintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        searchBar.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        searchBar.tintColor = Constants.Color.Primary
        
        chooseCityButton.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    }
    
    func onGetCityListResult(result: Bool, info: String, cityList: [String]) {
        self.clearAllNotice()
        if result {
            
            self.cityList = cityList
            
            self.chooseCityButton.setTitle(self.cityList[0], forState: .Normal)
            
            if Config.CurrentLocationInfo != nil {
                showDefaultLocationList(Config.CurrentLocationInfo!.coordinate)
            } else {
                locationService.startUserLocationService()
            
                self.noticeInfo("定位失败", autoClear: true, autoClearTime: 1)
                
                let option = BMKCitySearchOption()
                option.city = self.cityList[0]
                option.pageCapacity = 10
                option.keyword = self.cityList[0]
                self.poiSearch.poiSearchInCity(option)
            }
            
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        showDefaultLocationList(userLocation.location.coordinate)
        
        locationService.stopUserLocationService()
    }
    
    func showDefaultLocationList(coordinate: CLLocationCoordinate2D) {
        let localLatitude = coordinate.latitude
        let localLongitude = coordinate.longitude
        
        locationService.stopUserLocationService()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: localLatitude, longitude: localLongitude)) { (place, error) in
            if let placeData = place {
                for placeMark in placeData {
                    if placeMark.locality != nil {
                        let cityName = placeMark.locality!.stringByReplacingOccurrencesOfString("市", withString: "")
                    
                        for var city in self.cityList {
                            if city == cityName {
                                self.chooseCityButton.setTitle(cityName, forState: .Normal)
                                break
                            } else {
                                self.chooseCityButton.setTitle(self.cityList[0], forState: .Normal)
                            }
                        }
                    
                        let option = BMKCitySearchOption()
                        option.city = self.chooseCityButton.currentTitle
                        option.pageCapacity = 10
                        option.keyword = placeMark.name
                        self.poiSearch.poiSearchInCity(option)
                    }
                }
            }
        }
    }
    
    @IBAction func chooseCity(sender: UIButton) {
//        let cityVC = CFCityPickerVC()
//    
//        //设置热门城市
//        cityVC.hotCities = cityList
//        
//        let navVC = UINavigationController(rootViewController: cityVC)
//        navVC.navigationBar.barStyle = UIBarStyle.BlackTranslucent
//        
//        self.presentViewController(navVC, animated: true, completion: nil)
//        
//        //解析字典数据
//        let cityModels = cityModelsPrepare()
//        cityVC.cityModels = cityModels
//        
//        //选中了城市
//        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
//            self.chooseCityButton.setTitle(cityModel.name, forState: UIControlState.Normal)
//            self.chooseCityButton.setTitle(cityModel.name, forState: UIControlState.Highlighted)
//        }
        searchBar.resignFirstResponder()
        
        UsefulPickerView.showSingleColPicker("选择城市", data: cityList, defaultSelectedIndex: cityIndex) {[unowned self] (selectedIndex, selectedValue) in
            self.cityIndex = selectedIndex
            self.chooseCityButton.setTitle(selectedValue, forState: UIControlState.Normal)
            self.chooseCityButton.setTitle(selectedValue, forState: UIControlState.Highlighted)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let address = addressList[indexPath.row]
        delegate?.didChooseLocation(address.name, locationInfo: CLLocation(latitude: address.pt.latitude, longitude: address.pt.longitude))
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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

protocol ChooseLocationDelegate {
    func didChooseLocation(name: String, locationInfo: CLLocation)
}