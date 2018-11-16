//
//  WXUserDetailReform.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import CTNetworkingSwift
import SwiftyJSON


let kWXUserDetailTitle = "title"
let kWXUserDetailSubTitle = "subTitle"
let kWXUserDetailShowArrow = "showArrow"
let kWXUserDetailImageUrls = "imageUrls"
let kWXUserDetailImageUrl = "imageUrl"
let kWXUserDetailName = "name"
let kWXUserDetailWeixinNumber = "weixinNumber"
let kWXUserDetailRemarkName = "remarkName"
let kWXUserDetailSex = "sex"

struct WXUserDetailReform: CTNetworkingReformer {
    
    var wxId:String = ""
    
    func reform(apiManager:CTNetworkingBaseAPIManager) -> Any? {
        
        guard let json = apiManager.fetchAsJSON()?["data"] else {
            return nil
        }
        
        let headPicture = json["headPicture"].string
        let name = json["name"].stringValue
        let sex = json["sex"].intValue
        let phone = json["phone"].stringValue
        let province = json["province"].string ?? ""
        let city = json["city"].string ?? ""
        let district = json["district"].string ?? ""
        let remarkName = json["remarkName"].string
        let address = "\(province) \(city) \(district)"
        
        return [
            [
                [kWXUserDetailImageUrl:headPicture,kWXUserDetailName:name,kWXUserDetailWeixinNumber:wxId,kWXUserDetailRemarkName:remarkName,kWXUserDetailSex:sex]
            ],
            [
                [kWXUserDetailTitle:"设置备注和标签",kWXUserDetailShowArrow:true],
                [kWXUserDetailTitle:"电话号码",kWXUserDetailSubTitle:phone,kWXUserDetailShowArrow:false]
            ],
            [
                [kWXUserDetailTitle:"地区",kWXUserDetailSubTitle:address,"showArrow":false],
                [kWXUserDetailTitle:"个人相册",kWXUserDetailImageUrls:["https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1555162835,2120770057&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3972446805,2469332184&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1265907631,191003867&fm=26&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3222719360,565415155&fm=27&gp=0.jpg"],"showArrow":true],
                [kWXUserDetailTitle:"更多",kWXUserDetailShowArrow:true]
            ]
        ]
        
    }
}
