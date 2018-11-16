//
//  WXContactListApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON

class WXContactListApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
        paramSource = self
        validator = self
    }
}

extension WXContactListApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "contact/list"
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

extension WXContactListApiManager : CTNetworkingBaseAPIManagerParamSource {
    func params(for apiManager:CTNetworkingBaseAPIManager) -> ParamsType? {
        return nil
    }
}

extension WXContactListApiManager: WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        return CTNetworkingErrorType.Params.correct
    }
}



