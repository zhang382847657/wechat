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


// 图片缓存地址
let image_cache_file = NSTemporaryDirectory() + "ZLImageCache"

let kIconFontName = "iconfont"

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

enum IconFontType:String {
    case 心 = "\u{e613}"
    case 评论 = "\u{e66c}"
    case 表情 = "\u{e691}"
    case 键盘 = "\u{e624}"
    case 相机 = "\u{e611}"
    case 微信 = "\u{e6f8}"
    case 微信_选 = "\u{e604}"
    case 通讯录 = "\u{e648}"
    case 通讯录_选 = "\u{e605}"
    case 发现 = "\u{e633}"
    case 发现_选 = "\u{e6ea}"
    case 我 = "\u{e6ff}"
    case 我_选 = "\u{e639}"
    case 钱包 = "\u{e618}"
    case 相册 = "\u{e688}"
    case 表情_2 = "\u{e6a6}"
    case 设置 = "\u{e620}"
    case 扫一扫 = "\u{e608}"
    case 购物 = "\u{e65f}"
    case 小程序 = "\u{e61f}"
    case 标签 = "\u{e600}"
    case 新的朋友 = "\u{e616}"
    case 群聊 = "\u{e61e}"
    case 公众号 = "\u{e64d}"
    case 二维码 = "\u{e60a}"
    case 添加联系人 = "\u{e601}"
    case 耳朵 = "\u{e6ef}"
    case 收付款 = "\u{e606}"
    case 搜索 = "\u{e65c}"
    case 清空 = "\u{e60b}"
    case 语音 = "\u{e610}"
    case 添加 = "\u{e706}"
    case 免打扰 = "\u{e657}"
    case 男 = "\u{e60e}"
    case 女 = "\u{e607}"
    case 更多 = "\u{e619}"
    case 图片 = "\u{e70f}"
    case 图片失效 = "\u{e65a}"
    case 位置 = "\u{e623}"
    case 位置_选中 = "\u{e609}"
    case 艾特 = "\u{e697}"
    case 艾特_选中 = "\u{e653}"
    case 右箭头 = "\u{e715}"
    case 垃圾篓 = "\u{e670}"
    case 播放 = "\u{e60c}"
    case 暂停 = "\u{e60f}"
}

/// 语言类型
///
/// - english: 英文
/// - simple_chinese: 简体中文
enum LanguageType: String {
    case english = "en"
    case simple_chinese = "zh-Hans"
}

/// 国际化语言对应Key
enum LanguageKey: String {
    case 消息 = "Tabbar_Item_Message"
    case 通讯录 = "Tabbar_Item_Contacts"
    case 发现 = "Tabbar_Item_Discover"
    case 我 = "Tabbar_Item_Me"
    case 取消 = "Cancel"
    case 完成 = "Done"
    case 钱包 = "Wallet"
    case 收藏 = "Favorites"
    case 相册 = "My_Posts"
    case 卡包 = "Cards&Offers"
    case 表情 = "Sticker_Gallery"
    case 设置 = "Settings"
    case 朋友圈 = "Moments"
    case 扫一扫 = "Scan"
    case 摇一摇 = "Shake"
    case 看一看 = "Top_Stories"
    case 搜一搜 = "Search"
    case 附近的人 = "People_Nearby"
    case 漂流瓶 = "Message_in_a_Bottle"
    case 游戏 = "Games"
    case 购物 = "Shopping"
    case 小程序 = "Mini_Programs"
    case 新的朋友 = "New_Friends"
    case 群聊 = "Group_Chat"
    case 标签 = "Tags"
    case 公众号 = "Official_Accounts"
    case 搜索指定内容 = "Search_by_Type"
    case 文章 = "Article"
    case 小说 = "Novels"
    case 音乐 = "Music"
    case 表情_2 = "Stickers"
}



