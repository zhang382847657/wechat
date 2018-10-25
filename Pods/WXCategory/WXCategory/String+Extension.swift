//
//  StringExtension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation

public extension String {
    
    /// 转拼音
    public func transformToPinyin() -> String {
        
        let pinyin = NSMutableString(string: self)
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        return pinyin.folding(options: .diacriticInsensitive, locale: NSLocale.current)
        
    }
    
    
    /// 字符串转日期
    ///
    /// - Parameter dateFormat: 日期格式
    /// - Returns: Date
    public func stringConvertDate(dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }
    
}
