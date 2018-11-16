//
//  LoginReform.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/26.
//  Copyright © 2018年 张琳. All rights reserved.
//

import CTNetworkingSwift
import SwiftyJSON

class LoginReform: NSObject, CTNetworkingReformer {

    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        return apiManager.fetchAsJSON()?["data"]
    }
}
