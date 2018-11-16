//
//  WXUserDetailApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/1.
//  Copyright © 2018年 张琳. All rights reserved.
//


import Alamofire
import CTNetworkingSwift
import SwiftyJSON

class WXUserDetailApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
    }
}

extension WXUserDetailApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "user/detail"
    }
    
    var requestType: HTTPMethod {
        return .post
    }
    
    var service : CTNetworkingService {
        get {
            return WXService.sharedInstance
        }
    }
}



