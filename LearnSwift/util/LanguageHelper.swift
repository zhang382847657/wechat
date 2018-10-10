//
//  LanguageHelper.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit


/// 语言类型
///
/// - english: 英文
/// - simple_chinese: 简体中文
enum LanguageType: String {
    case english = "en"
    case simple_chinese = "zh-Hans"
}


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


/// 国际化工具类
class LanguageHelper: NSObject {
    
    /// 缓存国际化对应的KEY
    private let UserLanguage = "UserLanguage" //用户选择的语言

    /// 存储当前语言
    private let def = UserDefaults.standard
    var bundle : Bundle?
    
    /// 单例
    static let shareInstance : LanguageHelper = {
        
        let shared = LanguageHelper()
        var string:String = shared.def.value(forKey: shared.UserLanguage) as? String ?? Locale.preferredLanguages.first!
        
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        
        // 如果系统当前选择的语言国际化里没有配过的话，默认展示英语
        if LanguageType(rawValue: string) == nil {
            string = LanguageType.english.rawValue
        }
        
        let path = Bundle.main.path(forResource:string , ofType: "lproj")
        shared.bundle = Bundle(path: path!)
        return shared
    }()
    
    
    /// 通过国际化得到对应的字符串
    class func getString(key:LanguageKey) -> String{
        let bundle = LanguageHelper.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key.rawValue, value: nil, table: nil)
        return str!
    }
    
    
    /// 重新设置当前语言类型
    ///
    /// - Parameter langeuage: 语言类型  en 英语  zh-Hans 简体汉语
    func setLanguage(langeuage:String) {
        let path = Bundle.main.path(forResource:langeuage , ofType: "lproj")
        bundle = Bundle(path: path!)
        def.set(langeuage, forKey: UserLanguage)
        def.synchronize()
    }
    
    
    /// 跟随系统语言
    func resetSystemLanguage(){
        def.removeObject(forKey: UserLanguage)
        def.synchronize()
        var string:String = Locale.preferredLanguages.first!
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        let path = Bundle.main.path(forResource:string , ofType: "lproj")
        bundle = Bundle(path: path!)
    }
    

    /// 得到当前用户选择的语言
    ///
    /// - Returns: 返回当前语言  如果返回为nil，则代表跟随系统语言
    func getCurrentUserLanguage() -> String? {
        if var currentLanguage = def.value(forKey: UserLanguage) as? String {
            currentLanguage = currentLanguage.replacingOccurrences(of: "-CN", with: "")
            currentLanguage = currentLanguage.replacingOccurrences(of: "-US", with: "")
            return currentLanguage
        }
        return nil
    }
    
}
