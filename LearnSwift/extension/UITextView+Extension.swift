//
//  UITextView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/14.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    /// 设置占位字
    ///
    /// - Parameters:
    ///   - placeholdStr: 占位字
    ///   - color: 颜色
    ///   - font: 字体大小  可选 默认跟正文字体一样
    func setPlaceholder(placeholdStr:String, color:UIColor = Colors.fontColor.font999, font:UIFont? = nil){
        
        if let placeHoderLabel = self.value(forKey: "_placeholderLabel") as? UIView {
            placeHoderLabel.removeFromSuperview()
        }
        
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = placeholdStr
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = color
        placeHolderLabel.font = font ?? self.font
        placeHolderLabel.sizeToFit()
        self.addSubview(placeHolderLabel)
        
        // KVC键值编码，对UITextView的私有属性进行修改
        self.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
    }
    
}
