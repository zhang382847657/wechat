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
    
   
    private var dataSource:[[String:Any]] = []
    
    
    public func numberOfRowsInSection(section:Int) -> Int {
        return dataSource.count
        
    }
    
    public func getCellDataForRowAt(indexPath: IndexPath) -> Dictionary<String,Any> {
        return dataSource[indexPath.row]
    }
    
    
    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        
        
        if let dataList = apiManager.fetchAsJSON()?["data","dataList"].arrayObject as? [[String:Any]] {
            
            dataSource = dataList
            return dataSource
            
        }
        
        return nil
    }
}

