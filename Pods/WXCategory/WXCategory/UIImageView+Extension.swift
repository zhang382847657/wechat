//
//  UIImageView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    
    /// 设置加载中的图片以及加载失败的图片
    ///
    /// - Parameters:
    ///   - placeHolderImage: 加载中的图片
    ///   - failedImage: 图片加载失败的图
    ///   - isFailed: 是否加载失败的图  默认否
    public func setImageWith(placeHolderImage placeHolder:UIImage, failedImage failed:UIImage, isFailed:Bool = false) {
        self.image = isFailed ? failed : placeHolder
    }

}
