//
//  WXFriendCircleAddCommentApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/12/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON

/// 朋友圈添加评论
class WXFriendCircleAddCommentApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
        validator = self
    }
}

extension WXFriendCircleAddCommentApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "dynamic/addComment"
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


extension WXFriendCircleAddCommentApiManager: WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        
        guard let p = params, let _ = p["dynamicId"] as? Int , let content = p["content"] as? String , content.count > 0 else {
            return CTNetworkingErrorType.Params.missingParams
        }
        
        return CTNetworkingErrorType.Params.correct
    }
}
