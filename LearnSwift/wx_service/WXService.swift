//
//  WXService.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/26.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import CTNetworkingSwift
import Alamofire
import SwiftyJSON

/// 微信接口配置
class WXService: CTNetworkingService {
    static let _sharedInstance: CTNetworkingService = WXService()
    
    static var sharedInstance: CTNetworkingService {
        get {
            return _sharedInstance
        }
        set {
            // do nothing
        }
    }
    
    private lazy var baseURL:String = {
        if apiEnvironment == .Release {
            return "http://www.baidu.com/"
        }else if apiEnvironment == .Develop {
            return "http://localhost:3001/"
        }else {
            return "http://www.taobao.com/"
        }
    }()
    
    func request(params: ParamsType?, methodName: String, requestType: HTTPMethod) -> DataRequest {
        let urlString = "\(baseURL)\(methodName)"

        var httpHeaders = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8","Accept":"application/json; text/json; text/javascript; text/html; text/plain; charset=utf-8"]
        if let token = User.share.token {
            httpHeaders["Authorization"] = token
        }
        
        return sessionManager.request(urlString, method: requestType, parameters: params, headers: httpHeaders)
    }
    
    var apiEnvironment : CTNetworkingAPIEnvironment = .Develop
    
    let sessionManager: SessionManager = SessionManager()
    
    func handleCommonError(_ apiManager:CTNetworkingBaseAPIManager) -> Bool {
        
        guard let response = apiManager.response else {
            return false
        }
        
        if let error = response.error {
            print("网络请求异常 == \(error.localizedDescription)")
            return false
            
        } else {
            return true
        }
    }
}
