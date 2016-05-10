//
//  WithDrawModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class WithDrawModel : WithDrawProtocol {
    var withDrawDelegate: WithDrawDelegate?
    
    init(withDrawDelegate: WithDrawDelegate) {
        self.withDrawDelegate = withDrawDelegate
    }
    
    func doWithDraw(money: String, pwd: String) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                self.withDrawDelegate?.onWithDrawResult(false, info: "密码错误")
            })
        }
    }
}

protocol WithDrawDelegate {
    func onWithDrawResult(result: Bool, info: String)
}