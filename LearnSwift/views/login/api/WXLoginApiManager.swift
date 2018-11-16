//
//  WXLoginApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/26.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON

class WXLoginApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
    }
}

extension WXLoginApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "login"
    }
    
    var requestType: HTTPMethod {
        return .get
    }
    
    var service : CTNetworkingService {
        get {
            return WXService.sharedInstance
        }
    }
}



