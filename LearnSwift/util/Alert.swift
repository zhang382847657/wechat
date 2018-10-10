//
//  Alert.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/29.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class Alert: NSObject {

    
    /// 展示弹窗
    ///
    /// - Parameters:
    ///   - viewcontroller: 所在视图控制器
    ///   - title: 标题
    ///   - message: 内容
    ///   - done: 完成回调
    class func show(viewcontroller:UIViewController,title:String,message:String, done:@escaping (()->Void)){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel_action = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        let submit_action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            done()
        }
        alertVC.addAction(cancel_action)
        alertVC.addAction(submit_action)
        
        viewcontroller.present(alertVC, animated: true, completion: nil)
        
    }
}
