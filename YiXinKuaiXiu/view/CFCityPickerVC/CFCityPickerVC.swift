//
//  CFCityPickerVC.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

protocol CFCityPickerVCDelegate{
    
    func selectedCityModel(cityPicker: CFCityPickerVC, cityModel:CFCityPickerVC.CityModel)
}


class CFCityPickerVC: UIViewController {

    var delegate: CFCityPickerVCDelegate!
    
    var cityModels: [CityModel]!
    
    static let cityPVCTintColor = UIColor.grayColor()
    
    var searchBar: CitySearchBar!
    
    var searchRVC: CitySearchResultVC!
    
    /** 可设置：当前城市 */
    var currentCity: String!{didSet{getedCurrentCityWithName(currentCity)}}
    
    /** 可设置：热门城市 */
    var hotCities: [String]!
    
    lazy var indexTitleLabel: UILabel = {UILabel()}()

    var showTime: CGFloat = 1.0
    
    var indexTitleIndexArray: [Int] = []
    
    var selectedCityModel: ((cityModel: CityModel) -> Void)!
    
    lazy var dismissBtn: UIButton = { UIButton(frame: CGRectMake(0, 0, 24, 24)) }()
    
    lazy var selectedCityArray: [String] = {NSUserDefaults.standardUserDefaults().objectForKey(SelectedCityKey) as? [String] ?? []}()
    
    var currentCityItemView: HeaderItemView!

    deinit{
        print("控制器安全释放")
    }
    
    var tableView: UITableView!
}

/** 这里是无关的解析业务 */
extension UIViewController{
    
    /** 解析字典数据，由于swift中字典转模型工具不完善，这里先手动处理 */
    func cityModelsPrepare() -> [CFCityPickerVC.CityModel]{
        
        //加载plist，你也可以加载网络数据
        let plistUrl = NSBundle.mainBundle().URLForResource("City", withExtension: "plist")!
        let cityArray = NSArray(contentsOfURL: plistUrl) as! [NSDictionary]
        
        var cityModels: [CFCityPickerVC.CityModel] = []
        
        for dict in cityArray{
            let cityModel = parse(dict)
            cityModels.append(cityModel)
        }
        
        return cityModels
    }
    
    func parse(dict: NSDictionary) -> CFCityPickerVC.CityModel{
        
        let id = dict["id"] as! Int
        let pid = dict["pid"] as! Int
        let name = dict["name"] as! String
        let spell = dict["spell"] as! String
        
        let cityModel = CFCityPickerVC.CityModel(id: id, pid: pid, name: name, spell: spell)
        
        let children = dict["children"]
        
        if children != nil { //有子级
            
            var childrenArr: [CFCityPickerVC.CityModel] = []
            for childDict in children as! NSArray {
                
                let childrencityModel = parse(childDict as! NSDictionary)
                
                childrenArr.append(childrencityModel)
            }
            
            cityModel.children = childrenArr
        }
        
        
        return cityModel
    }
    
}

