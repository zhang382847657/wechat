//
//  BaseTableView.swift
//  arena
//
//  Created by 张琳 on 2018/3/17.
//  Copyright © 2018年 江苏斑马软件技术有限公司. All rights reserved.
//

import UIKit


/// 自带下拉刷新+上拉加载更多的TableView
/// 好处
/// - 不需要关心刷新和上拉加载的操作
/// - 不需要记录当前请求的页码
/// - 只需要关心网络请求的数据的接口
///
/// 使用说明
///
/// - 请在子类中实现BaseTableViewDelegate代理协议中的
/// `func loadData(pageNumber:Int)`方法，在该方法中进行网络数据请求，请求成功，请调用
/// ` self.data = json["dataList"].arrayValue`，
/// 如果请求失败，请调用 `self.data = nil`
/// - 如果想让页面刷新同时带有刷新动画，请调用`self.mj_header.beginRefreshing()`
/// - 如果想让页面刷新但又不想展示刷新头部，请调用`self.silentRefresh()`



/// BaseTableView代理
protocol BaseTableViewDelegate {
    
    /// 加载网络数据
    ///
    /// - Parameter pageNumber: 当前页码
    func loadData(pageNumber:Int)
}

class BaseTableView: UITableView {
    
    /// 代理
    public var baseDelegate:BaseTableViewDelegate?
    
    /// 总数据源
    public final var dataList:Array<JSON> = []
    
    /// 当前的数据
    public var data:Array<JSON>? {
        didSet{
            updateUI()
        }
    }
    /// 一页显示条数
    public var pageSize:Int = 20
    
    /// 是否需要头部刷新
    public var needRefreshHeaderView:Bool = true {
        didSet {
            if needRefreshHeaderView {
                self.addHeaderRefresh(actionTarget: self, action: #selector(refresh))
            }
        }
    }
    
    /// 是否需要尾部加载更多
    public var needLoadMoreFooterView:Bool = true {
        didSet {
            if needLoadMoreFooterView {
                self.addFooterLoadMore(actionTarget: self, action: #selector(loadMore))
            }
        }
    }
    
    /// 自定义头部刷新组件
    public var refreshHeaderView:BaseRefreshView? {
        didSet{
            if refreshHeaderView != nil {
                self.addHeaderRefresh(headerView: refreshHeaderView!, actionTarget: self, action: #selector(refresh))
            }
        }
    }
    
    /// 自定义尾部加载更多组件
    public var loadMoreFooterView:BaseFooterLoadMoreView? {
        didSet{
            if loadMoreFooterView != nil {
                self.addFooterLoadMore(footerView: loadMoreFooterView!, actionTarget: self, action: #selector(loadMore))
            }
        }
    }
    
    /// 当前是否是刷新状态
    private var isRefresh:Bool = true
   
    
    /// 静默刷新，不会触发头部刷新动画
    public func silentRefresh(){
        self.isRefresh = true
        self.loadData(pageNumber: 0)
    }
    
    
    /// 支持代码创建
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configTable()
    }
    
    
    /// 支持Xib创建
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configTable()
    }
    
    
    
    /// TableView的一些基本配置
    private func configTable(){
        
        self.separatorStyle = .singleLine
        self.separatorColor = Colors.backgroundColor.coloree
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.backgroundColor = UIColor.clear
        self.keyboardDismissMode = .onDrag
        
        self.needRefreshHeaderView = true
        self.needLoadMoreFooterView = true
        
    }
    
    /// 下拉刷新
    @objc private func refresh(){
        self.isRefresh = true
        self.loadData(pageNumber: 0)
    }
    
    /// 上拉加载更多
    @objc private func loadMore(){
        self.isRefresh = false
        self.loadData(pageNumber: self.dataList.count/self.pageSize)
    }
    
    /// 请求网络数据
    ///
    ///
    /// - Parameters:
    ///   - pageNumber: 页码
    private func loadData(pageNumber:Int){
        self.baseDelegate?.loadData(pageNumber: pageNumber)
    }
    
    
    /// 重新拼装数据并刷新界面
    private func updateUI(){
        if let data = data {
            
            if isRefresh == true {  //如果是下拉刷新
                self.endRefresh() //停止刷新动画
                self.dataList = [] //清空数据源
            }
            
            self.dataList += data  //数组合并
            
            if data.count < self.pageSize{
                
                if self.tableFooterView != nil {
                    self.endLoadMoreWithNoData() //尾部显示没有更多数据
                }
                
            }else{
                if self.tableFooterView != nil {
                    self.endLoadMore() //结束尾部刷新
                }
            }
            
            self.reloadData()  //刷新数据源
            
        }else{
            self.endRefresh() //停止刷新动画
            if self.tableFooterView != nil {
                self.endLoadMore() //结束尾部刷新
            }
        }
    }
    
    
}

