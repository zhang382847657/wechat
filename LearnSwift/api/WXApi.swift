//
//  WXApi.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class WXApi: NSObject {

    
    /// 登录
    ///
    /// - Parameters:
    ///   - wxId: 微信号
    ///   - password: 密码
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func login(wxId:String, password:String, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        
        NetWork.get(url: "login", param: ["wxId":wxId,"password":password], success: success, failed: failed)
    }
    
    
    /// 朋友圈
    ///
    /// - Parameters:
    ///   - pageNum: 页码
    ///   - pageSize: 一页显示条数
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicList(pageNum:Int, pageSize:Int, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        
         NetWork.post(url: "dynamic/list", param: ["pageSize":pageSize,"pageNum":pageNum], success: success, failed: failed)
    }
    
    
    /// 联系人列表
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func contactList(success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "contact/list", param: nil, success: success, failed: failed)
    }
    
    
    /// 查询用户详情
    ///
    /// - Parameters:
    ///   - wxId: 微信号
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func queryUserInfo(wxId:String, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "user/detail", param: ["wxId":wxId], success: success, failed: failed)
    }
    
    
    
    /// 查询某一条动态是否已经点赞
    ///
    /// - Parameters:
    ///   - dynamicId: 动态ID
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicIsLike(dynamicId:Int, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/isLike", param: ["dynamicId":dynamicId], success: success, failed: failed)
    }
    
    
    /// 动态点赞
    ///
    /// - Parameters:
    ///   - dynamicId: 动态ID
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicLike(dynamicId:Int, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/like", param: ["dynamicId":dynamicId], success: success, failed: failed)
    }
    
    
    /// 动态取消点赞
    ///
    /// - Parameters:
    ///   - dynamicId: 动态Id
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynmaicCancelLike(dynamicId:Int, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/cancelLike", param: ["dynamicId":dynamicId], success: success, failed: failed)
    }
    
    
    /// 动态添加一条评论
    ///
    /// - Parameters:
    ///   - dynamicId: 动态ID
    ///   - content: 评论内容
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicAddComment(dynamicId:Int, content:String, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/addComment", param: ["dynamicId":dynamicId, "content":content], success: success, failed: failed)
    }
    
    
    
    /// 动态回复评论
    ///
    /// - Parameters:
    ///   - dynamicId: 动态ID
    ///   - replyUserId: 回复对象的ID
    ///   - content: 回复内容
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicReplyComment(dynamicId:Int, replyUserId:Int, content:String, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/replyComment", param: ["dynamicId":dynamicId, "content":content, "replyUserId":replyUserId], success: success, failed: failed)
    }
    
    
    /// 删除动态评论
    ///
    /// - Parameters:
    ///   - commentId: 评论ID
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicDeleteComment(commentId:Int, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/deleteComment", param: ["commentId":commentId], success: success, failed: failed)
    }

    
    /// 添加一条动态
    ///
    /// - Parameters:
    ///   - content: 文案
    ///   - pictures: 照片
    ///   - longitude: 经度
    ///   - latitude: 纬度
    ///   - country: 国家
    ///   - province: 省
    ///   - city: 市
    ///   - district: 区
    ///   - street: 街道
    ///   - substreet: 子街道
    ///   - placeName: 地名
    ///   - video: 视频
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func dynamicAdd(content:String?, pictures:String?, longitude:Double?, latitude:Double?, country:String?, province:String?, city:String?, district:String?, street:String?, substreet:String?, placeName:String?, video:String?, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        NetWork.post(url: "dynamic/add", param: ["content":content, "pictures":pictures, "longitude":longitude, "latitude":latitude, "country":country, "province":province, "city":city, "district":district, "street":street, "substreet":substreet, "placeName":placeName], success: success, failed: failed)
    }
    
}
