//
//  EmptyDataView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/12.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools


/// 暂无数据占位图
class EmptyDataView: UIView {
    

    /// 图标
    private lazy var iconView:UIImageView = {
        
        let v = UIImageView(image:  IconFont(code: IconFontType.暂无数据.rawValue, name: kIconFontName, fontSize: 40, color: Colors.fontColor.font999).iconImage)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
    }()
    
    /// 提示词
    private lazy var tipLabel:UILabel = {
       let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "暂无数据"
        l.textColor = Colors.fontColor.font999
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
  
    
    /// 唯一初始化
    required init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        addSubview(iconView)
        addSubview(tipLabel)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            tipLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            tipLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            tipLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
