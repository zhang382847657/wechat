//
//  ContactViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/16.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import CTNetworkingSwift

class ContactViewController: UIViewController {
    
    /// UITabelView
    @IBOutlet weak var tableView: UITableView!
    /// 搜索控制器
    var searchController:ContactSearchController!
    /// 联系人ApiManager
    private lazy var wxContactListApiManager:WXContactListApiManager = {
        let m = WXContactListApiManager.init()
        m.delegate = self
        return m
    }()
    /// 联系人数据过滤器
    private let wxContactListRefrom = WXContactListReform()
    /// 菜单Cell标识符
    private let cell_contactMenuCell = "ContactMenuCell"
    /// 联系人Cell标识符
    private let cell_contactUserCell = "ContactUserCell"
    /// 网络异常占位图
    private let networkErrorView = NetWorkErrorView(reladTarget: self, reloadAction: #selector(loadData))
    /// 暂无数据占位图
    private let emptyDataView = EmptyDataView()
    /// 当前占位图
    private var currentPlaceholderView = UIView()
    /// 网络状态管理
    private lazy var networkReachabilityManager:ZLNetworkReachabilityManager = {
        let n = ZLNetworkReachabilityManager.share
        n.delegate = self
        return n
    }()
    
    
    /// 唯一初始化
    required init() {
        super.init(nibName: "ContactViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LanguageHelper.getString(key: LanguageKey.通讯录.rawValue)
        
       
        // 导航栏右侧添加联系人图标
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:  IconFont(code: IconFontType.添加联系人.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, style: .plain, target: self, action: #selector(addContactClick))
        
        // 注册Cell
        tableView.register(UINib(nibName: "ContactMenuCell", bundle: nil), forCellReuseIdentifier: cell_contactMenuCell)
        tableView.register(UINib(nibName: "ContactUserCell", bundle: nil), forCellReuseIdentifier: cell_contactUserCell)
        
        // tableview索引颜色
        tableView.sectionIndexColor = Colors.fontColor.font666
        tableView.keyboardDismissMode = .onDrag
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    
        // 搜索视图控制器
        searchController = ContactSearchController(tableView: tableView, viewController: self)
        self.definesPresentationContext = true

        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
       
        // 加载数据
        loadData()
    
        // 开启网络监听
        networkReachabilityManager.startListening()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        // 结束网络监听
        networkReachabilityManager.stopListening()
    }
    
    
    /// 加载数据
    @objc private func loadData(){
        wxContactListApiManager.loadData()
    }

    
    /// 添加联系人
    @objc private func addContactClick(){
        
    }
   

}


// MARK: - UITableViewDataSource , UITableViewDelegate
extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return wxContactListRefrom.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wxContactListRefrom.numberOfRowsInSection(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ContactMenuCell = tableView.dequeueReusableCell(withIdentifier: cell_contactMenuCell) as! ContactMenuCell
            cell.data = wxContactListRefrom.getCellDataForRowAt(indexPath: indexPath)
            return cell
        }else{
            let cell:ContactUserCell = tableView.dequeueReusableCell(withIdentifier: cell_contactUserCell) as! ContactUserCell
            cell.data = wxContactListRefrom.getCellDataForRowAt(indexPath: indexPath)
            return cell
        }
        
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return wxContactListRefrom.sectionIndexTitles
    }
   
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
        header.textLabel?.textColor = Colors.fontColor.font999
        header.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return wxContactListRefrom.titleForHeaderInSection(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section != 0 {
            let userDetailVC = UserDetailViewController(wxId: wxContactListRefrom.getCellDataForRowAt(indexPath: indexPath)[kWXContactListUserWXId] as! String)
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
    
    
}


// MARK: - 占位图
extension ContactViewController : PlaceholderView {
    var placeholderView: UIView {
        get {
            return currentPlaceholderView
        }
        set {

        }
    }
    
   
    //var placeholderView: UIView = networkErrorView
}


// MARK: - 网络状态
extension ContactViewController : ZLNerworkReachabilityDelegate {
    
    /// 网络状态变化
    func networkStateChange(state: ZLNetworkReachableState) {
        print("当前网络状态 == ", state)
        
        switch state {
        case .notReachable:
            currentPlaceholderView = networkErrorView
            showPlaceholderView()
        default:
            loadData()
            hidenPlaceholderView()
        }
    }
}


// MARK: - API请求结果
extension ContactViewController: CTNetworkingBaseAPIManagerCallbackDelegate {
    
    /// 请求成功
    func requestDidSuccess(_ apiManager:CTNetworkingBaseAPIManager) {
        
        hidenPlaceholderView()
        let _ = apiManager.fetch(reformer: wxContactListRefrom)
        tableView.reloadData()
    }
    
    /// 请求失败
    func requestDidFailed(_ apiManager:CTNetworkingBaseAPIManager) {
        
        print("联系人接口异常")
    }
}


