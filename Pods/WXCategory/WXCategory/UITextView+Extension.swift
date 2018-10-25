//
//  UITextView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/14.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    
    /// 设置提示词
    ///
    /// - Parameters:
    ///   - string: 提示文案
    ///   - color: 提示颜色
    ///   - font: 提示字体大小  可选 默认跟正文字体一样
    public func setPlaceholderWith(string placehold:String, color:UIColor, font:UIFont? = nil){
        
        if let placeHoderLabel = self.value(forKey: "_placeholderLabel") as? UIView {
            placeHoderLabel.removeFromSuperview()
        }
        
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = placehold
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = color
        placeHolderLabel.font = font ?? self.font
        placeHolderLabel.sizeToFit()
        self.addSubview(placeHolderLabel)
        
        // KVC键值编码，对UITextView的私有属性进行修改
        self.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
    }
    
}
