//
//  MenuModel.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

struct MenuModel {
    
    var iconfont:String?
    var iconImage:String?
    var iconColor:String?
    var title:String?
    
    init(dic:[String:Any]) {
        iconfont = dic["iconfont"] as? String
        iconImage = dic["iconImage"] as? String
        iconColor = dic["iconColor"] as? String
        title = dic["title"] as? String
    }
    
}
