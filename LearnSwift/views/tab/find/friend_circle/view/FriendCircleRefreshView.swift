//
//  FriendCircleRefreshView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/15.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit


/// 朋友圈头部刷新视图
class FriendCircleRefreshView: BaseRefreshView {

    /// 最小刷新拖拽距离
    override var minDragDistanse: CGFloat {
        get {
            return super.minDragDistanse
        }
        set {
            super.minDragDistanse = 100
        }
    }
    
    /// 转圈的图片
    private lazy var circleImageView:UIImageView = {
        let c = UIImageView(image: UIImage(named: "pengyouquan"))
        // 转圈的图片
        c.translatesAutoresizingMaskIntoConstraints = false
        c.isHidden = true
        self.addSubview(c)
        return c
    }()
    

    
    /// 转圈图片顶部约束
    private var circleTopContraint:NSLayoutConstraint!
    /// 滚动视图偏移量
    private var contentOffsetY:CGFloat = 0
    /// 记录上一次滚动视图偏移量
    private var lastContentOffsetY:CGFloat = 0
    
    
    /// 刷新状态
    override var refreshState: Refresh_State {
        didSet{
            
            if refreshState == oldValue {
                if oldValue == .begin_refresh {
                    dragTransAnimation()
                }
                return
            }
            
            switch refreshState {
            case .noraml:
                doNormalRefresh()
            case .begin_refresh:
                doBeginRefresh()
            case .refreshing:
                doRefreshing()
            }
        }
    }

    /// 旋转动画图层
    private lazy var transLayer:CALayer = {
        let l = CALayer()
        l.frame = circleImageView.bounds
        l.contents = circleImageView.image?.cgImage
        circleImageView.layer.addSublayer(l)
        return l
    }()
    
    /// 旋转动画
    private lazy var rotationAnim:CABasicAnimation = {
        // 1.创建动画
        let a = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        a.fromValue = 0
        a.toValue = Double.pi * 2
        a.repeatCount = MAXFLOAT
        a.duration = 0.3
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        a.isRemovedOnCompletion = false
        
        return a
    }()
    

    override func setupUI() {
        
        self.backgroundColor = UIColor.clear
        
        circleTopContraint = circleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.shared.statusBarFrame.height)
        NSLayoutConstraint.activate([
            circleTopContraint,
            circleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            circleImageView.widthAnchor.constraint(equalToConstant: 20),
            circleImageView.heightAnchor.constraint(equalTo: circleImageView.widthAnchor)
            ])
    }
    
    /// 让触摸透传，防止父视图下拉拖拽失效
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    
    /// 滚动Y轴变化的时候
    ///
    /// - Parameter y: y坐标
    override func adjustY(y:CGFloat){
        
        // 让刷新头部视图一直停留在顶部，不随拖拽而移动
        var f = self.frame
        f.origin.y = -y
        self.frame = f

        contentOffsetY = y

        let parentView:UIScrollView = self.superview! as! UIScrollView

        if parentView.isDragging {
            if y < minDragDistanse {
                refreshState = .noraml
            }else {
                refreshState = .begin_refresh
            }
        }else {
            if y >= minDragDistanse {
                refreshState = .refreshing
            }else{
                circleImageView.layer.removeAnimation(forKey: "dragTransAnimation")
                if refreshState == .begin_refresh {
                    refreshState = .noraml
                }
            }
        }

    }
    
    
    /// 开始下拉
    override func doNormalRefresh(){
        
        // 移除旋转动画，重置图片的位置
        transLayer.removeAnimation(forKey: "circleImageViewRotation")
        circleTopContraint.constant = UIApplication.shared.statusBarFrame.height
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layoutSubviews()
        }) { [weak self](_) in
            self?.circleImageView.isHidden = true
        }
        
    }
    
    
    
    /// 将要刷新的时候
    override func doBeginRefresh(){
        circleTopContraint.constant = UIApplication.shared.statusBarFrame.height + 44 + 30
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.circleImageView.isHidden = false
            self?.layoutSubviews()
        }
    }
    
    
    /// 正在刷新
    override func doRefreshing(){
        
        super.doRefreshing()
        
        transLayer.add(rotationAnim, forKey: "circleImageViewRotation")
    }
    
    
    /// 跟随用户向下拖拽时进行旋转动画
    private func dragTransAnimation(){
        // 1.创建动画
        let a = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        a.fromValue = CGFloat(Double.pi * 2) / 360 * (lastContentOffsetY - minDragDistanse)
        a.toValue = CGFloat(Double.pi * 2) / 360 * (contentOffsetY - minDragDistanse)
        a.repeatCount = 1
        a.duration = 0.1
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        a.isRemovedOnCompletion = false
        
        lastContentOffsetY = contentOffsetY
        
        circleImageView.layer.add(a, forKey: "dragTransAnimation")
    }
    
}
