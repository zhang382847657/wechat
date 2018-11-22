//
//  WeixinCellModel.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/21.
//  Copyright © 2018年 张琳. All rights reserved.
//


/// 朋友圈视图模型
struct WeixinCellModel {
    
    /// 朋友圈ID
    var id:Int
    /// 用户头像
    var headerImageUrl:String?
    /// 用户昵称
    var name:String?
    /// 朋友圈内容
    var content:String?
    /// 朋友圈发布时间
    var time:String?
    /// 朋友圈显示位置
    var location:String?
    /// 朋友圈内容是否展开
    var showAll:Bool
    /// 朋友圈发布的图片数据
    var dynamicImageUrls:[String] = []
    /// 朋友圈点赞数据
    var likesData:[[String:Any]]?
    /// 朋友圈评论数据
    var commentData:[[String:Any]]?
    /// 是否点过赞
    var isLike:Bool
    
    
    
    /// 唯一初始化
    ///
    /// - Parameter dic: 字典
    init(dic:[String:Any]) {
        
        
        let user:[String:Any] = dic["user"] as? [String : Any] ?? [:]
        
        id = dic["id"] as! Int
        headerImageUrl = user["headPicture"] as? String
        name = user["name"] as? String
        content = dic["content"] as? String
        time = dic["createtime"] as? String
        time = time?.stringConvertDate()?.dateConvertFriendCircleType()
       
        showAll = dic["isSelect"] as? Bool ?? false
        
        let pictures = dic["pictures"] as? String
        dynamicImageUrls = pictures?.components(separatedBy: ",") ?? []
        
        likesData = dic["likes"] as? [[String : Any]]
        commentData = dic["comment"] as? [[String : Any]]
        isLike = dic["isLike"] as? Bool ?? false
        
        let placeName = dic["placeName"] as? String
        let city = dic["city"] as? String
       
        if let city = city {
            location = city
            if let placeName = placeName {
                location! += "·\(placeName)"
            }
        }
        
    }
    
    
    
}


