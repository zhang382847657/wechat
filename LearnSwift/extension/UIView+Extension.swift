//
//  UIView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/9.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// 加载xib
    ///
    /// - Parameter nibName: xib的文件名
    /// - Returns: 返回xib对应的视图
    static func loadViewFromNib(nibName:String) -> UIView? {
        
        let nibView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        
        if let view = nibView?.first as? UIView{
            return view
        }
        return nil
    }
    
    
    /// 设置圆角
    ///
    /// - Parameters:
    ///   - radio: 圆角值 默认为nil 代表绘制圆形
    ///   - borderColor: 边框颜色  默认为nil
    ///   - borderWidth: 边框大小  默认为nil
    func setCornerRadio(radio:CGFloat? = nil, borderColor:UIColor? = nil, borderWidth:CGFloat? = nil){
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: radio == nil ? self.bounds.size : CGSize(width: radio!, height: radio!))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        if let borderColor = borderColor, let borderWidth = borderWidth {
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskPath.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
        }
    }
    
    
    
    /// 添加底部分割线
    ///
    /// - Parameters:
    ///   - color: 横线颜色  默认分割线颜色
    ///   - size: 横线大小 默认0.5
    ///   - left: 横线距离左侧间距  默认15
    ///   - right: 横线距离右侧间距  默认0
    func addBottomLineWith(color:UIColor = Colors.backgroundColor.colordc, size:CGFloat = 0.5, left:CGFloat = 15.0, right:CGFloat = 0.0) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),lineView.heightAnchor.constraint(equalToConstant: size),lineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left),lineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -right)])
        
        
    }
    
}
