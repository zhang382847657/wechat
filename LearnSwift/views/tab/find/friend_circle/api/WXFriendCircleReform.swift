//
//  WXFriendCircleReform.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/15.
//  Copyright © 2018年 张琳. All rights reserved.
//


import CTNetworkingSwift
import SwiftyJSON


class WXFriendCircleReform: CTNetworkingReformer  {
    
    var dataSource:[WeixinCellModel] = []
    
    
    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        
        if let wxFriendCircleApiManager = apiManager as? WXFriendCircleApiManager {
            
            if let dataList = wxFriendCircleApiManager.fetchAsJSON()?["data","dataList"].arrayObject as? [[String:Any]] {
                
                let finalDataList = dataList.map { (dic) -> WeixinCellModel in
                    return WeixinCellModel(dic: dic)
                }
                
                if wxFriendCircleApiManager.isFirstPage {
                     dataSource = finalDataList
                }else {
                     dataSource += finalDataList
                }
                
                return dataSource
            }
        }
        
        return nil
    }
}

