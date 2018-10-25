//
//  UIViewController+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {

    
    
    /// 获取屏幕最上层视图控制器
    ///
    /// - Parameter vc: 父类视图控制器  默认是跟视图控制器
    /// - Returns: 视图控制器
    public class func getCurrentViewController(vc: UIViewController = UIApplication.shared.keyWindow!.rootViewController!) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            return getCurrentViewController(vc: (vc as! UINavigationController).visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            return getCurrentViewController(vc: (vc as! UITabBarController).selectedViewController!)
            
        } else {
            
            if (vc.presentedViewController != nil) {
                return getCurrentViewController(vc: vc.presentedViewController!)
            } else {
                return vc
            }
            
        }

    }
}
