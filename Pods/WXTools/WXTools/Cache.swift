//
//  Cache.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/25.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 内存缓存
public class Cache: NSObject, NSCacheDelegate {
    
    ///单例对象
    public static let share = Cache()

    ///NSCache
    private lazy var cache:NSCache<AnyObject, AnyObject> = {
       let _cache = NSCache<AnyObject, AnyObject>()
        _cache.countLimit = 500 //设置缓存条目
        _cache.totalCostLimit = 10 * 1024 * 1024 //设置缓存大小
        _cache.delegate = self
        return _cache
    }()
    
    
    
    /// 设置缓存
    ///
    /// - Parameters:
    ///   - obj: 缓存对象
    ///   - key: key
    public func setObject(obj:AnyObject, forKey key:String){
        cache.setObject(obj, forKey: key as AnyObject)
    }
    
    
    /// 获取缓存内容
    ///
    /// - Parameter key: key
    /// - Returns: 返回缓存对象
    public func getObject(forkey key:String) -> AnyObject?{
        return cache.object(forKey: key as AnyObject)
    }

    
    //MARK: NSCacheDelegate
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("NSCache缓存将要被删除")
    }
    
}
