//
//  UIScrollView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/14.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit


private var myContext = 0
private var myRefreshViewKey = 100
private var myLoadMoreViewKey = 101

public extension UIScrollView {
    
    /// 头部刷新视图
    public var refreshView: BaseRefreshView? {
        set {
            objc_setAssociatedObject(self, &myRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &myRefreshViewKey) as? BaseRefreshView
        }
    }
    
    /// 尾部加载更多视图
    public var loadMoreView: BaseFooterLoadMoreView? {
        set {
            objc_setAssociatedObject(self, &myLoadMoreViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &myLoadMoreViewKey) as? BaseFooterLoadMoreView
        }
    }
    
    
    
    /// 添加头部刷新
    ///
    /// - Parameters:
    ///   - actionTarget: 事件实现目标
    ///   - action: 事件
    public func addHeaderRefresh(headerView:BaseRefreshView = BaseRefreshView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)), actionTarget:AnyObject?, action:Selector?){
    
        self.refreshView = headerView
        self.refreshView?.action = action
        self.refreshView?.actionTarget = actionTarget
        self.addSubview(self.refreshView!)
        
        weak var weakSelf = self
        if let weakSelf1 = weakSelf {
            weakSelf1.addObserver(weakSelf1, forKeyPath: "contentOffset", options: .new, context: &myContext)
        }
    }
    
    
    public func addFooterLoadMore(footerView:BaseFooterLoadMoreView = BaseFooterLoadMoreView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)),actionTarget:AnyObject?, action:Selector?){
        
        self.loadMoreView = footerView
        self.loadMoreView?.action = action
        self.loadMoreView?.actionTarget = actionTarget
        
       
        if self is UITableView {
            (self as! UITableView).tableFooterView = self.loadMoreView
        }
        
        weak var weakSelf = self
        if let weakSelf1 = weakSelf {
            weakSelf1.addObserver(weakSelf1, forKeyPath: "contentOffset", options: .new, context: &myContext)
        }
    }
    
    /// 开始下拉刷新
    public func beginRefresh(){
        self.refreshView?.beginRefresh()
    }

    /// 结束下拉刷新
    public func endRefresh(){
        self.refreshView?.endRefresh()
    }

    /// 结束上拉加载更多
    public func endLoadMore(){
        self.loadMoreView?.endLoading()
    }

    /// 结束上拉加载更多并已经是最后一页
    public func endLoadMoreWithNoData(){
        self.loadMoreView?.endLoadingWithNoData()
    }
    
    /// 移除刷新时候的监听 在子类的deinit方法中调用
    public func removeRefreshObserver(){
        self.removeObserver(self, forKeyPath: "contentOffset", context: &myContext)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if context == &myContext {
            guard let key = keyPath,
                let change = change,
                let newValue = change[.newKey] as? CGPoint
                else { return }
            
            if key == "contentOffset" {
                
                // 根据Y的位置做出对应刷新效果
                self.refreshView?.adjustY(y: -newValue.y)
                
                // 根据Y的位置做出对应上拉加载效果
                self.loadMoreView?.adjustY(y: newValue.y)
                
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }

    }
    
}
