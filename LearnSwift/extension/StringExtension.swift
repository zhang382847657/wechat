//
//  StringExtension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
extension String {
 
    /// MD5加密
    func md5() -> String {
        
        let cStrl = cString(using: String.Encoding.utf8);
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        
        var md5String = ""
        
        for idx in 0...15 {
            
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            
            md5String.append(obcStrl);
            
        }
        
        free(buffer);
        
        return md5String
    }
    
    /// 转拼音
    func transformToPinyin() -> String {
        
        let pinyin = NSMutableString(string: self)
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        return pinyin.folding(options: .diacriticInsensitive, locale: NSLocale.current)
        
    }
    
    
    /// 字符串转日期
    ///
    /// - Parameter dateFormat: 日期格式
    /// - Returns: Date
    func stringConvertDate(dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }
    
}
