//
//  Config.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/5.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

/// 屏幕大小
let screenBounds:CGRect = UIScreen.main.bounds
/// 获取当前系统版本
let appVersion:String = UIDevice.current.systemVersion


/// 接口请求的API固定前缀
#if DEVELOPMENT
let api_url:String = "http://localhost:3001/"
#else
let api_url:String = "https://www.baidu.com/"
#endif



/// 颜色
struct Colors {
    
    
    /// 字体颜色
    struct fontColor {
        static let font333 = UIColor(hex: "#333333")
        static let font666 = UIColor(hex: "#666666")
        static let font999 = UIColor(hex: "#999999")
    }
    
    
    /// 主题色
    struct themeColor {
        static let main = UIColor(hex: "#62b900") //绿色
        static let main2 = UIColor(hex: "#353438") //黑色
        static let main3 = UIColor(hex: "#3A6CB2") //蓝色
    }
    
    
    /// 背景色
    struct backgroundColor {
        static let main = UIColor(hex: "#f3f4f5")
        static let coloree = UIColor(hex: "#eeeeee")
        static let colordc = UIColor(hex: "#dcdcdc")
        static let colorcc = UIColor(hex: "#cccccc")
        
       
    }
}


