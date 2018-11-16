//
//  BaseFooterLoadMoreView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/25.
//  Copyright © 2018年 张琳. All rights reserved.
//


import UIKit


/// 上拉加载状态枚举类型
///
/// - noraml: 开始上拉加载
/// - begin_loadMore: 将要上拉加载
/// - loading: 加载中
/// - noData: 没有更多数据
public enum LoadMore_State:Int {
    case noraml
    case begin_loadMore
    case loading
    case noData
}


/// 上拉加载更多的基类
open class BaseFooterLoadMoreView: UIView {
    
  
    /// 事件实现目标
    open var actionTarget:AnyObject?
    /// 事件
    open var action:Selector?
    /// 最小上拉加载拖拽距离
    open var minDragDistanse:CGFloat = 40
    
    /// 刷新状态
    open var refreshState:LoadMore_State = .noraml {
        
        didSet{
            switch refreshState {
            case .noraml:
                doNormalLoading()
            case .begin_loadMore:
                doBeginLoadMore()
            case .loading:
                doLoading()
            case .noData:
                doNoData()
            }
        }
    }
    
    
    open lazy var loadingLabel:UILabel = {
        let l = UILabel()
        l.text = "上拉加载更多"
        l.textColor = UIColor.gray
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    /// 布局UI
    open func setupUI(){
        self.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            loadingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            loadingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            loadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
    }
    
    
    
    /// 开始上拉加载
    open func beginLoading(){
        self.refreshState = .loading
    }
    
    
    /// 结束上拉加载
    open func endLoading(){
        self.refreshState = .noraml
    }
    
    /// 结束上拉加载并且已经是最后一页
    open func endLoadingWithNoData(){
        self.refreshState = .noData
    }
    
    
    /// 滚动Y轴变化的时候
    ///
    /// - Parameter y: y坐标
    open func adjustY(y:CGFloat){
        
        if refreshState == .loading || refreshState == .noData || y <= 0 {
            return
        }
        
        
        let parentView:UIScrollView = self.superview! as! UIScrollView
        
        let finalY = y + parentView.frame.height - parentView.contentSize.height
        
        if parentView.isDragging {
            if finalY < minDragDistanse {
                refreshState = .noraml
            }else {
                refreshState = .begin_loadMore
            }
        }else {
            if finalY >= minDragDistanse && refreshState != .loading {
                refreshState = .loading
            }
        }
    }
    
    
    /// 开始上拉加载
    open func doNormalLoading(){
        loadingLabel.text = "上拉加载更多"
    }
    
    
    /// 将要上拉加载更多
    open func doBeginLoadMore(){
        loadingLabel.text = "松开立即加载"
    }
    
    
    /// 加载中
    open func doLoading(){
        guard let actionTarget = actionTarget, let action = action else {
            return
        }
        
        let _ = actionTarget.perform(action)
        
        loadingLabel.text = "加载中(≧∇≦)ﾉ"
    }
    
    open func doNoData(){
        loadingLabel.text = "- 别拉了，我是有底线的人 -"
    }
    
    
}
