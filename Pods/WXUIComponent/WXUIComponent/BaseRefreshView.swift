//
//  BaseRefreshView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/25.
//  Copyright © 2018年 张琳. All rights reserved.
//


import UIKit


/// 刷新状态枚举类型
///
/// - noraml: 开始下拉刷新
/// - begin_refresh: 将要刷新
/// - refreshing: 刷新中
public enum Refresh_State:Int {
    case noraml
    case begin_refresh
    case refreshing
}


/// 下拉刷新的基类
open class BaseRefreshView: UIView {
    
    /// 事件实现目标
    open var actionTarget:AnyObject?
    /// 事件
    open var action:Selector?
    /// 最小刷新拖拽距离
    open var minDragDistanse:CGFloat = 100
   
    /// 刷新状态
    open var refreshState:Refresh_State = .noraml {
        
        didSet{
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
    
    /// 下拉刷新Label
    open lazy var refreshLabel:UILabel = {
        let l = UILabel()
        l.text = "下拉刷新"
        l.textColor = UIColor.gray
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI(){
        self.addSubview(refreshLabel)
        NSLayoutConstraint.activate([
            refreshLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            refreshLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            refreshLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            refreshLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
    }
    
    
    
    /// 开始刷新
    open func beginRefresh(){
        self.refreshState = .refreshing
    }
    
    
    /// 结束刷新
    open func endRefresh(){
        isAdjustToNormal(normal: true)
        self.refreshState = .noraml
    }
    
    
    /// 滚动Y轴变化的时候
    ///
    /// - Parameter y: y坐标
    open func adjustY(y:CGFloat){
        
        let parentView:UIScrollView = self.superview! as! UIScrollView
        
        if parentView.isDragging {
            if y < minDragDistanse {
                refreshState = .noraml
            }else {
                refreshState = .begin_refresh
            }
        }else {
            if y >= minDragDistanse && refreshState != .refreshing {
                refreshState = .refreshing
            }else{
//                if refreshState == .begin_refresh {
//                    refreshState = .noraml
//                }
            }
        }
        
        
    }
    
    
    /// 开始下拉
    open func doNormalRefresh(){
       
        refreshLabel.text = "下拉刷新"
    }
    
    
    /// 将要刷新的时候
    open func doBeginRefresh(){
        
        refreshLabel.text = "松开立即刷新"
    }
    
    
    /// 正在刷新
    open func doRefreshing(){
        guard let actionTarget = actionTarget, let action = action else {
            return
        }
        
        isAdjustToNormal(normal: false)
        let _ = actionTarget.perform(action)
        
        refreshLabel.text = "刷新中……"
        
        let parentView:UIScrollView = self.superview! as! UIScrollView
        // 调用这个方法是为了如果用户上拉到已经没有数据的时候，又进行了下拉刷新的操作，应该恢复重新可以上拉的操作
        parentView.endLoadMore()
    }
    
    
    /// 自动调整
    ///
    /// - Parameter normal: 是否开始下拉刷新
    open func isAdjustToNormal(normal:Bool){
        let parentView:UIScrollView = self.superview! as! UIScrollView
        
        var y:CGFloat = 0
        if normal == false {
            y = self.frame.height
        }
        UIView.animate(withDuration: 0.5) {
            parentView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

}
