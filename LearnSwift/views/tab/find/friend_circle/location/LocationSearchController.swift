//
//  LocationSearchController.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/8.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 自定义搜索视图控制器
class LocationSearchController: UISearchController, UISearchBarDelegate, UISearchControllerDelegate {
    
    /// 搜索结果视图
    private var searchResultController:LocationSearchResultViewController!
    /// UITableView
    private var tableView:UITableView!
    /// 自定义搜索框
    private let locationSearchBar = LocationSearchBar(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: 50))
    /// 重写父类搜索框
    override var searchBar: LocationSearchBar  {
        get {
            return locationSearchBar
        }
    }
    /// 父视图控制器
    private var vc:UIViewController!
    
    
    /// 唯一初始化
    ///
    /// - Parameters:
    ///   - tableView: TableView
    ///   - viewController: 父视图控制器
    required init(tableView:UITableView,viewController:UIViewController) {
        
        // 搜索结果视图控制器
        let resultVC = LocationSearchResultViewController()
        super.init(searchResultsController:resultVC)
        
        self.tableView = tableView
        self.vc = viewController
        self.searchResultController = resultVC
        
        
        // 设置代理，searchResultUpdater是UISearchController的一个属性，它的值必须实现UISearchResultsUpdating协议，这个协议让我们的类在UISearchBar文字改变时被通知到，我们之后会实现这个协议。
        searchResultsUpdater = self.searchResultController

        // 保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上
        definesPresentationContext = true
        
        // iOS11之后searchController有了新样式，可以放在导航栏
        if #available(iOS 11.0, *) {
            navigationItem.searchController = self
        } else {
            tableView.tableHeaderView = searchBar
        }
        
        
        delegate = self
        
        searchBar.delegate = self
        
        searchBar.clearClickBack = {
            self.searchResultController.searchLocationWith(keyword: nil)
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: viewWillAppear只执行一次，不知道为什么 导致从结果页push后再返回会不走这里，就无法隐藏tabbar
        vc.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 点击Cancel按钮，设置不显示搜索结果并刷新列表
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultController.searchLocationWith(keyword: nil)
    }
    
    /// 点击搜索按钮，触发该代理方法，如果已经显示搜索结果，那么直接去除键盘，否则刷新列表
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultController.searchLocationWith(keyword: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultController.searchLocationWith(keyword: searchText)
    }
    
    
    /// 将要展示搜索结果页面 隐藏tabbar
    func willPresentSearchController(_ searchController: UISearchController) {
        vc.tabBarController?.tabBar.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        vc.tabBarController?.tabBar.isHidden = false
    }
    
}

