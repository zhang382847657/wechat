//
//  WXFriendCircleApiManager.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/15.
//  Copyright © 2018年 张琳. All rights reserved.
//


import Alamofire
import CTNetworkingSwift
import SwiftyJSON


class WXFriendCircleApiManager: CTNetworkingBaseAPIManager, CTNetworkingAPIManagerPagable {
    
    var pageSize: Int = 10
    
    var isLastPage: Bool = false
    
    var isFirstPage: Bool = true
    
    var currentPageNumber: Int = 0
    
    var totalCount: Int?
    

    override init() {
        super.init()
        child = self
        paramSource = self
        validator = self

    }
    
    override func loadData() {
        isFirstPage = true
        currentPageNumber = 0
        super.loadData()
    }
    
    func loadNextPage() {
        
        if isLastPage {
            interceptor?.didReceiveResponse(self)
            return
        }
        
        if !isLoading {
            super.loadData()
        }
    }
    
}

extension WXFriendCircleApiManager : CTNetworkingBaseAPIManagerChild {
    var isPagable: Bool {
        return true
    }
    
    var methodName: String {
        return "dynamic/list"
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

extension WXFriendCircleApiManager : CTNetworkingBaseAPIManagerParamSource {
    func params(for apiManager: CTNetworkingBaseAPIManager) -> ParamsType? {
        return ["pageSize":pageSize,"pageNum":currentPageNumber]
    }
}

extension WXFriendCircleApiManager : WXBaseAPIManagerValidator {
    func isCorrect(manager: CTNetworkingBaseAPIManager, params: ParamsType?) -> CTNetworkingErrorType.Params {
        return CTNetworkingErrorType.Params.correct
    }
}


extension WXFriendCircleApiManager : CTNetworkingBaseAPIManagerInterceptor {
    override func beforePerformSuccess(_ apiManager:CTNetworkingBaseAPIManager) -> Bool {

        let totalPageCount = Int(ceil(apiManager.fetchAsJSON()!["data","totalCount"].doubleValue / Double(pageSize)))

        if currentPageNumber == totalPageCount - 1 {
            isLastPage = true
        } else {
            isLastPage = false
        }
        currentPageNumber += 1
        return super.beforePerformSuccess(apiManager)

    }


    override func beforePerformFail(_ apiManager:CTNetworkingBaseAPIManager) -> Bool {
        let _ = super.beforePerformFail(apiManager)
        return true
    }
}



