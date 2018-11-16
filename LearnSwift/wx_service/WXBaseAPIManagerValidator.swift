//
//  WX.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import SwiftyJSON
import CTNetworkingSwift
import Alamofire

/// 微信自定义接口验证器
protocol WXBaseAPIManagerValidator : CTNetworkingBaseAPIManagerValidator {
    
}

extension WXBaseAPIManagerValidator {
    
    /// 这里统一进行接口返回的验证
    func isCorrect(manager: CTNetworkingBaseAPIManager, response: DefaultDataResponse) -> CTNetworkingErrorType.Response {
        
        guard let data = response.data else {
            return .missingInfomation
        }
        
        guard let result = try? JSON(data: data) else {
            return .missingInfomation
        }
        
        if result["result"].stringValue == "ok" {
            return .correct
        }else {
            
            switch result["rescode"].intValue {
            case 202: 
                print("未登录")
                gotoLogin()
                return .missingInfomation
            case 203 :
                print("登录过期")
                User.share.clearUserInfo()
                gotoLogin()
                return .missingInfomation
            default :
                print("其他原因 == \(result["msg"].stringValue)")
                return .missingInfomation
            }
        }
    }
    
    
    /// 去重新登录
    private func gotoLogin(){
        let loginVC = LoginViewController()
        UIViewController.getCurrentViewController().present(loginVC, animated: true, completion: nil)
    }
}
