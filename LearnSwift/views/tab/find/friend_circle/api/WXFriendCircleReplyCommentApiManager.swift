//
//  WXFriendCircleReplyCommentApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/12/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Alamofire
import CTNetworkingSwift
import SwiftyJSON

/// 朋友圈回复评论
class WXFriendCircleReplyCommentApiManager: CTNetworkingBaseAPIManager {
    
    override init() {
        super.init()
        child = self
        validator = self
    }
}

extension WXFriendCircleReplyCommentApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return false
    }
    
    var methodName: String {
        return "dynamic/replyComment"
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


extension WXFriendCircleReplyCommentApiManager: WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        
        guard let p = params, let _ = p["dynamicId"] as? Int , let content = p["content"] as? String , content.count > 0, let _ = p["replyUserId"] as? Int else {
            return CTNetworkingErrorType.Params.missingParams
        }
        
        return CTNetworkingErrorType.Params.correct
    }
}
