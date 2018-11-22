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
    
   
    private var dataSource:[WeixinCellModel] = []
    
    
    public func numberOfRowsInSection(section:Int) -> Int {
        return dataSource.count
        
    }
    
    public func getCellDataForRowAt(indexPath: IndexPath) -> WeixinCellModel {
        return dataSource[indexPath.row]
    }
    
    
    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        
        
        if let dataList = apiManager.fetchAsJSON()?["data","dataList"].arrayObject as? [[String:Any]] {
            
            let finalDataList = dataList.map { (dic) -> WeixinCellModel in
                return WeixinCellModel(dic: dic)
            }
            
            dataSource = finalDataList
            return dataSource
        }
        
        return nil
    }
}

