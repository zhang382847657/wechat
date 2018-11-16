//
//  WXContactListReform.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/31.
//  Copyright © 2018年 张琳. All rights reserved.
//
import CTNetworkingSwift
import SwiftyJSON

let kWXContactListMenuIcon = "icon"
let kWXContactListMenuBGColor = "bgColor"
let kWXContactListMenuTitle = "title"
let kWXContactListSortContactsKey = "key"
let kWXContactListSortContactsValue = "value"
let kWXContactListUserWXId = "wxId"

class WXContactListReform: CTNetworkingReformer  {
    
    private var menu = [
        [kWXContactListMenuIcon:IconFontType.新的朋友.rawValue,kWXContactListMenuBGColor:"#FF8C00",kWXContactListMenuTitle:LanguageKey.新的朋友],
        [kWXContactListMenuIcon:IconFontType.群聊.rawValue,kWXContactListMenuBGColor:"#62b900",kWXContactListMenuTitle:LanguageKey.群聊],
        [kWXContactListMenuIcon:IconFontType.标签.rawValue,kWXContactListMenuBGColor:"#4169E1",kWXContactListMenuTitle:LanguageKey.标签],
        [kWXContactListMenuIcon:IconFontType.公众号.rawValue,kWXContactListMenuBGColor:"#4169E1",kWXContactListMenuTitle:LanguageKey.公众号]]
    
    private var contacts:[[String:Any]] = []
    
    private var sortContacts:[[String:Any]] = []
    
    public var sectionIndexTitles:[String] = []
    
    
    public func numberOfSections() -> Int {
        return 1 + sectionIndexTitles.count
    }
    
    public func numberOfRowsInSection(section:Int) -> Int {
        if section == 0 {
            return menu.count
        }else{
            let contants = sortContacts[section - 1][kWXContactListSortContactsValue]! as! Array<Dictionary<String,Any>>
            return contants.count
        }
    }
    
    public func getCellDataForRowAt(indexPath: IndexPath) -> Dictionary<String,Any> {
        if indexPath.section == 0 {
           return menu[indexPath.row]
        }else{
            return (sortContacts[indexPath.section - 1][kWXContactListSortContactsValue]! as! [[String:Any]])[indexPath.row]
        }
    }
    
    public func titleForHeaderInSection(section:Int) -> String? {
        if section == 0 {
            return nil
        }
        return sortContacts[section - 1][kWXContactListSortContactsKey]! as? String
    }
    
    
    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        
        
        if let dataList = apiManager.fetchAsJSON()?["data","dataList"].arrayObject as? [[String:Any]] {
            
            contacts = dataList
            
            // 最终排序好后的字典  ["A":[["imageUrl":"***","name":"Arise"]],"B":[["imageUrl":"***","name":"Bill"]]]
            var sortedDataSource:Dictionary<String,Array<Dictionary<String,Any>>> = [:]
            for user in dataList {
                
                let name:String = user["name"] as! String
                // 获取名字的首字母
                let firstWord = name.transformToPinyin().prefix(1).uppercased()
                
                if var array  = sortedDataSource[firstWord] {
                    array.append(user)
                    sortedDataSource[firstWord] = array
                }else {
                    sortedDataSource[firstWord] = [user]
                }
            }
            
            sectionIndexTitles = sortedDataSource.keys.sorted()
            
            for value in sectionIndexTitles {
                sortContacts.append([kWXContactListSortContactsKey:value,kWXContactListSortContactsValue:sortedDataSource[value]!])
            }
            
        }
        
        return nil
    }
}

