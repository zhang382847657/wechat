//
//  Date+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/28.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation


public extension Date {
    
    /// 转成日期字符串格式
    ///
    /// - Parameter dateFormat: 日期格式
    /// - Returns: 日期字符串
    public func dateConvertString(dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String {
        
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date.components(separatedBy: " ").first!
    }
    
    
    
    /// 转成朋友圈日期字符串类型 比如刚刚、几分钟前、几天前等
    ///
    /// - Returns: 日期字符串
    public func dateConvertFriendCircleType() -> String {
        
        //获取当前时间
        let calendar = Calendar.current
        //判断是否是今天
        if calendar.isDateInToday(self as Date) {
            //获取当前时间和系统时间的差距(单位是秒)
            //强制转换为Int
            let since = Int(Date().timeIntervalSince(self as Date))
            //  是否是刚刚
            if since < 60 {
                return "刚刚"
            }
            //  是否是多少分钟内
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            //  是否是多少小时内
            return "\(since / (60 * 60))小时前"
        }
        
        //判断是否是昨天
        var formatterString = " HH:mm"
        if calendar.isDateInYesterday(self as Date) {
            formatterString = "昨天" + formatterString
        } else {
            //判断是否是一年内
            formatterString = "MM-dd" + formatterString
            //判断是否是更早期
            
            let comps = calendar.dateComponents([Calendar.Component.year], from: self, to: Date())
            
            if comps.year! >= 1 {
                formatterString = "yyyy-" + formatterString
            }
        }
        
        //按照指定的格式将日期转换为字符串
        //创建formatter
        let formatter = DateFormatter()
        //设置时间格式
        formatter.dateFormat = formatterString
        //设置时间区域
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        
        //格式化
        return formatter.string(from: self as Date)
    }
    
}
