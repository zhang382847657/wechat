//
//  LanguageHelper.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit


/// 国际化工具类
public class LanguageHelper: NSObject {
    
    /// 缓存国际化对应的KEY
    private let kLanguageHelperUserLanguage = "kLanguageHelperUserLanguage"

    /// 存储当前语言
    private let def = UserDefaults.standard
    public var bundle : Bundle?
    
    /// 单例
    public static let shareInstance : LanguageHelper = {
        
        let shared = LanguageHelper()
        var string:String = shared.def.value(forKey: shared.kLanguageHelperUserLanguage) as? String ?? Locale.preferredLanguages.first!
        
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        
//        // 如果系统当前选择的语言国际化里没有配过的话，默认展示英语
//        if LanguageType(rawValue: string) == nil {
//            string = LanguageType.english.rawValue
//        }
        
        let path = Bundle.main.path(forResource:string , ofType: "lproj")
        shared.bundle = Bundle(path: path!)
        return shared
    }()
    
    
    /// 通过国际化得到对应的字符串
    public class func getString(key:String) -> String{
        let bundle = LanguageHelper.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return str!
    }
    
    
    /// 重新设置当前语言类型
    ///
    /// - Parameter langeuage: 语言类型  en 英语  zh-Hans 简体汉语
    public func setLanguage(langeuage:String) {
        let path = Bundle.main.path(forResource:langeuage , ofType: "lproj")
        bundle = Bundle(path: path!)
        def.set(langeuage, forKey: kLanguageHelperUserLanguage)
        def.synchronize()
    }
    
    
    /// 跟随系统语言
    public func resetSystemLanguage(){
        def.removeObject(forKey: kLanguageHelperUserLanguage)
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
    public func getCurrentUserLanguage() -> String? {
        if var currentLanguage = def.value(forKey: kLanguageHelperUserLanguage) as? String {
            currentLanguage = currentLanguage.replacingOccurrences(of: "-CN", with: "")
            currentLanguage = currentLanguage.replacingOccurrences(of: "-US", with: "")
            return currentLanguage
        }
        return nil
    }
    
}
