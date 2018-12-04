//
//  WXFriendCircleDeleteCommentApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/12/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON


/// 朋友圈删除自己的评论
class WXFriendCircleDeleteCommentApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
        validator = self
    }
}

extension WXFriendCircleDeleteCommentApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "dynamic/deleteComment"
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


extension WXFriendCircleDeleteCommentApiManager: WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        
        guard let p = params, let _ = p["commentId"] as? Int else {
            return CTNetworkingErrorType.Params.missingParams
        }
        
        return CTNetworkingErrorType.Params.correct
    }
}
