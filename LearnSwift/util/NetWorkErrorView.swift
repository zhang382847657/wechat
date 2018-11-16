//
//  NetWorkErrorView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/12.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools


/// 网络连接失败占位图
class NetWorkErrorView: UIView {
    
    
    /// 图标
    private lazy var iconView:UIImageView = {
        
        let v = UIImageView(image:  IconFont(code: IconFontType.网络连接失败.rawValue, name: kIconFontName, fontSize: 40, color: Colors.fontColor.font999).iconImage)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
    }()
    
    /// 提示词
    private lazy var tipLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "网络出问题了，请检查网络"
        l.textColor = Colors.fontColor.font999
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    
    /// 重新加载按钮
    private lazy var reloadBtn:UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("重新加载", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        b.backgroundColor = Colors.themeColor.main
        b.addTarget(target, action: action, for: .touchUpInside)
        b.layer.cornerRadius = 5
        return b
    }()
    
    /// 响应重新加载对象
    private var target:Any!
    /// 响应重新加载事件
    private var action:Selector!

   
    
    /// 唯一初始化
    ///
    /// - Parameters:
    ///   - target: 响应重新加载事件对象
    ///   - reloadAction: 响应重新加载事件
    required init(reladTarget target:Any, reloadAction action:Selector) {
        
        self.target = target
        self.action = action
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        addSubview(iconView)
        addSubview(tipLabel)
        addSubview(reloadBtn)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            tipLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            tipLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            tipLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            reloadBtn.widthAnchor.constraint(equalToConstant: 120),
            reloadBtn.heightAnchor.constraint(equalToConstant: 45),
            reloadBtn.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 20),
            reloadBtn.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
