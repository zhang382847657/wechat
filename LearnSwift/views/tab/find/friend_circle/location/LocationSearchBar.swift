//
//  LocationSearchBar.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/8.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

/// 自定义搜索框
class LocationSearchBar: UISearchBar {
    
    public var clearClickBack:(()->Void)? //清除按钮点击回调
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    /// 自定义样式
    private func setupUI() {
        
        //设置默认显示内容
        placeholder = "搜索附近位置"
        //设置searchBar自适应大小
        sizeToFit()
        // 设置搜索框填充色
        barTintColor = Colors.backgroundColor.main
        //去掉搜索框上下的黑色横线
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        // 设置取消按钮颜色
        tintColor = Colors.themeColor.main
        
        
        //设置搜索图标
        setImage(IconFont(code: IconFontType.搜索.rawValue, name:kIconFontName, fontSize: 16.0, color: Colors.fontColor.font999).iconImage, for: .search, state: .normal)
        //设置搜索图片的偏移量
        setPositionAdjustment(UIOffsetMake(4, 0), for: .search)
        //设置清除按钮的图标
        setImage(IconFont(code: IconFontType.清空.rawValue, name:kIconFontName, fontSize: 16.0, color: Colors.fontColor.font999).iconImage, for: .clear, state: .normal)
        
        
        // 通过KVO找到输入框，并设置输入框的圆角
        let searchTF:UITextField? = self.value(forKeyPath: "searchField") as? UITextField
        if let searchTF = searchTF {
            searchTF.layer.cornerRadius = 6
            searchTF.layer.masksToBounds = true
            searchTF.textColor = Colors.fontColor.font333
            searchTF.font = UIFont.systemFont(ofSize: 14)
            searchTF.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
            searchTF.setValue(Colors.fontColor.font999, forKeyPath: "_placeholderLabel.textColor")
            
            let clearBtn:UIButton? = searchTF.value(forKey: "_clearButton") as? UIButton
            if let clearBtn = clearBtn {
                clearBtn.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
            }
        }
        
    }
    
    
    /// 清除按钮点击
    ///
    /// - Parameter sender: 清除按钮
    @objc private func clearClick(sender:UIButton){
        if let clearClickBack = clearClickBack {
            clearClickBack()
        }
    }
    
}
