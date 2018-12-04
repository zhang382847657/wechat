//
//  UserDetailViewModel.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/12/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

struct UserDetailHeaderViewModel {
    /// 当前显示的名字
    var name:String!
    /// 昵称
    var nickName:String?
    /// 头像
    var headerImageUrl:String?
    /// 微信号
    var wxNumber:String!
    /// 性别
    var sexTitle:String?
    /// 性别色值
    var sexColor:UIColor?

    
    init(dic:[String:Any]) {
        
        headerImageUrl = dic[kWXUserDetailImageUrl] as? String
        wxNumber = "微信号：\(dic[kWXUserDetailWeixinNumber] as! String)"
        
        
        
        if let name = dic[kWXUserDetailName] as? String {
            
            self.name = name
            
            if let remarkName = dic[kWXUserDetailRemarkName] as? String {
                self.name = remarkName
                nickName = "昵称：\(name)"
            }
        }
        
    
        let sex:Int = dic[kWXUserDetailSex] as? Int ?? 2 //性别 0女  1男 2未知
      
        switch sex {
        case 0:
            sexTitle = IconFontType.女.rawValue
            sexColor = UIColor(hex: "#F30000")
        case 1:
            sexTitle = IconFontType.男.rawValue
            sexColor = UIColor(hex: "#007AFF")
        default:
            break
        }
    }
}

struct UserDetailDefaltViewModel {
    
    /// 标题
    var title:String?
    /// 副标题
    var subTitle:String?
    /// Cell箭头类型
    var accessoryType:UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
    
    init(dic:[String:Any]) {
        title = dic[kWXUserDetailTitle] as? String
        subTitle = dic[kWXUserDetailSubTitle] as? String
        accessoryType = ( dic[kWXUserDetailShowArrow] as? Bool ?? false ) ? UITableViewCellAccessoryType.disclosureIndicator : UITableViewCellAccessoryType.none
    }
}

struct UserDetailPhotoViewModel {
    
    /// 标题
    var title:String?
    /// 第一张图片url地址
    var firstImageUrl:String?
    /// 第二张图片url地址
    var secondImageUrl:String?
    /// 第三张图片url地址
    var thirdImageUrl:String?
    /// 第四张图片url地址
    var fourthImageUrl:String?
    
    init(dic:[String:Any]) {
        
        title = dic[kWXUserDetailTitle] as? String
        
        let imageUrls = dic[kWXUserDetailImageUrls] as? Array<String> ?? []
        for(index,value) in imageUrls.enumerated() {
            switch index {
                case 0 :
                    firstImageUrl = value
                case 1:
                    secondImageUrl = value
                case 2:
                    thirdImageUrl = value
                case 3:
                    fourthImageUrl = value
                default:
                    break
            }
        }
    }
}

