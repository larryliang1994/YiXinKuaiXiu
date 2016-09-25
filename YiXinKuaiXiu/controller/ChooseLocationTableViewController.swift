//
//  ChooseLocationTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import UsefulPickerView

class ChooseLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate, GetInitialInfoDelegate, BMKGeoCodeSearchDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var chooseCityButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var addressList = [BMKPoiInfo]()
    
    var delegate: ChooseLocationDelegate?
    
    var cityList: [String] = []
    var cityIndex = 0
    
    let poiSearch = BMKPoiSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
        poiSearch.delegate = self
        
        self.pleaseWait()
        
        GetInitialInfoModel(getInitialInfoDelegate: self).getCityList()
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
            
            if Config.CurrentLocationInfo != nil {
                showDefaultLocationList(Config.CurrentLocationInfo!.coordinate)
            } else {
                self.chooseCityButton.setTitle(self.cityList[0], forState: .Normal)
                
                let option = BMKCitySearchOption()
                option.city = self.cityList[0]
                option.pageCapacity = 10
                option.keyword = self.cityList[0]
                self.poiSearch.poiSearchInCity(option)
            
                self.noticeInfo("定位失败", autoClear: true, autoClearTime: 1)
            }
            
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func showDefaultLocationList(coordinate: CLLocationCoordinate2D) {
        
        let searcher = BMKGeoCodeSearch()
        searcher.delegate = self
        
        let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = coordinate
        let flag = searcher.reverseGeoCode(reverseGeoCodeSearchOption)
        
        if !flag {
            self.chooseCityButton.setTitle(self.cityList[0], forState: .Normal)
            
            let option = BMKCitySearchOption()
            option.city = self.cityList[0]
            option.pageCapacity = 10
            option.keyword = self.cityList[0]
            self.poiSearch.poiSearchInCity(option)
        }
    }
    
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            let cityName = result.addressDetail.city.stringByReplacingOccurrencesOfString("市", withString: "")
            
            var located = false
            
            for city in self.cityList {
                let realCityName = city.stringByReplacingOccurrencesOfString("市", withString: "")
                                        .stringByReplacingOccurrencesOfString("区", withString: "")
                
                if realCityName == cityName {
                    self.chooseCityButton.setTitle(cityName, forState: .Normal)
                    located = true
                    break
                }
            }

            if !located {
                self.chooseCityButton.setTitle(self.cityList[0], forState: .Normal)
            }
            
            let option = BMKCitySearchOption()
            option.city = self.chooseCityButton.currentTitle
            option.pageCapacity = 30

            if result.addressDetail.streetName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 2 {
                option.keyword = result.address
            } else {
                option.keyword = cityName
            }

            self.poiSearch.poiSearchInCity(option)
        }
    }
    
    @IBAction func chooseCity(sender: UIButton) {
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
        
        if list != nil && list.count != 0 {
           addressList = list as! [BMKPoiInfo]
            
            tableView.reloadData()
        }
    }
}

protocol ChooseLocationDelegate {
    func didChooseLocation(name: String, locationInfo: CLLocation)
}
