//
//  User.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 用户信息
class User: NSObject {
    
    static let share = User()
    
    private let UserKey:String = "WX_USER"
    private let UserLocationKey:String = "WX_USER_LOCATION"
    
    var token:String? //token
    var id:Int? //用户ID
    var name:String? //昵称
    var phone:String? //手机号
    var headPicture:String? //头像
    var sex:Int = 2 //性别 0女 1男 2未知
    var wxId:String? //微信号
    var province:String? //省
    var city:String? //市
    var district:String? //区
    var pwd:String? //密码
    
    
    override init() {
        super.init()
        
        // 先从缓存中读取用户信息，并进行赋值
        if let jsonString = UserDefaults.standard.string(forKey: UserKey) {
            setValueForJson(json: JSON(parseJSON: jsonString))
        }
    }
    
    /// 保存用户登录信息
    public func saveUserLoginInfo(json:JSON){
        setValueForJson(json: json)
    }
    
    /// 清空用户信息
    public func clearUserInfo(){
        id = nil
        token = nil
        name = nil
        phone = nil
        headPicture = nil
        sex = 0
        wxId = nil
        province = nil
        city = nil
        district = nil
        pwd = nil
        UserDefaults.standard.removeObject(forKey: UserKey)
    }
    
    
    /// 保存用户当前经纬度信息
    ///
    /// - Parameters:
    ///   - lat: 经度
    ///   - long: 纬度
    public func saveUserLocation(lat:Double, long:Double){
        UserDefaults.standard.set(["lat":lat,"long":long], forKey: UserLocationKey)
    }
    
    
    /// 获得用户当前经纬度信息
    ///
    /// - Returns: 返回经纬度
    public func getUserLocation() -> (lat:Double, long:Double)? {
        let dic = UserDefaults.standard.value(forKey: UserLocationKey) as? [String:Double]
        if let dic = dic, let lat = dic["lat"], let long = dic["long"] {
            return (lat, long)
        }
        return nil
    }

    /// 根据json对象保存同步用户对象信息
    ///
    /// - Parameter json: json对象
    private func setValueForJson(json:JSON){
        
        token = json["token"].string
        id = json["id"].int
        name = json["name"].string
        phone = json["phone"].string
        headPicture = json["headPicture"].string
        sex = json["sex"].int ?? 2
        wxId = json["wxId"].string
        province = json["province"].string
        city = json["city"].string
        district = json["district"].string
        pwd = json["pwd"].string
        
        UserDefaults.standard.set(json.rawString([.castNilToNSNull : true]), forKey: UserKey)
    }

}
