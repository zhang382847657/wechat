//
//  WXFriendCircleLikeApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/12/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON


/// 朋友圈点赞
class WXFriendCircleLikeApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
        validator = self
    }
}

extension WXFriendCircleLikeApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "dynamic/like"
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


extension WXFriendCircleLikeApiManager: WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        
        guard let params = params, let _ = params["dynamicId"] as? Int else {
            return CTNetworkingErrorType.Params.missingParams
        }
        
        return CTNetworkingErrorType.Params.correct
    }
}
