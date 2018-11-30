//
//  UserDetailViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import CTNetworkingSwift

class UserDetailViewController: UITableViewController {
    
    /// 数据源
    private var dataSource:[[[String:Any]]] = []
    /// 微信号
    private var wxId:String = ""
    
    /// 查询用户详情的接口管理器
    private lazy var wxUserDetailApiManager:WXUserDetailApiManager = {
       let m = WXUserDetailApiManager.init()
        m.delegate = self
        m.paramSource = self
        m.validator = self
        return m
    }()
    /// 查询哦用户详情的数据过滤器
    private var wxUserDetailReform = WXUserDetailReform.init()
    
    private let cell_userDetailHeaderCell = "UserDetailHeaderCell"
    private let cell_userDetailDefaultCell = "UserDetailDefaultCell"
    private let cell_userDetailPhotoCell = "UserDetailPhotoCell"
    
    
    /// 唯一初始化
    ///
    /// - Parameter wxId: 微信号
    required init(wxId:String) {
        super.init(style: .grouped)
        self.wxId = wxId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "详细资料"
        
        // 导航栏右侧更多图标
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconFont(code: IconFontType.更多.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, style: .plain, target: self, action: #selector(moreClick))
        

        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.sectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0.1
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
       
        tableView.register( UINib(nibName: "UserDetailHeaderCell", bundle: nil), forCellReuseIdentifier: cell_userDetailHeaderCell)
        tableView.register( UINib(nibName: "UserDetailDefaultCell", bundle: nil), forCellReuseIdentifier: cell_userDetailDefaultCell)
        tableView.register(UINib(nibName: "UserDetailPhotoCell", bundle: nil), forCellReuseIdentifier: cell_userDetailPhotoCell)
        
        //调用接口查询用户信息
        wxUserDetailApiManager.loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 更多点击
    @objc private func moreClick(){
        
    }
    
}

//MARK: UITableView - DataSource
extension UserDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:UserDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: cell_userDetailHeaderCell, for: indexPath) as! UserDetailHeaderCell
            cell.data = dataSource[indexPath.section][indexPath.row]
            return cell
        }else if indexPath.section == 2 && indexPath.row == 1 {
            let cell:UserDetailPhotoCell = tableView.dequeueReusableCell(withIdentifier: cell_userDetailPhotoCell, for: indexPath) as! UserDetailPhotoCell
            cell.data = dataSource[indexPath.section][indexPath.row]
            return cell
        }else{
            let cell:UserDetailDefaultCell = tableView.dequeueReusableCell(withIdentifier: cell_userDetailDefaultCell, for: indexPath) as! UserDetailDefaultCell
            cell.data = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
    }
}

//MARK: UITableView - Delegate
extension UserDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: 接口成功/失败
extension UserDetailViewController : CTNetworkingBaseAPIManagerCallbackDelegate {
    func requestDidSuccess(_ apiManager: CTNetworkingBaseAPIManager) {
        
        dataSource = apiManager.fetch(reformer: wxUserDetailReform) as! [[[String : Any]]]
        tableView.reloadData()
        
    }
    func requestDidFailed(_ apiManager: CTNetworkingBaseAPIManager) {
        
    }
}

//MARK:  接口参数设置
extension UserDetailViewController : CTNetworkingBaseAPIManagerParamSource {
    func params(for apiManager:CTNetworkingBaseAPIManager) -> ParamsType? {
        return ["wxId":wxId]
    }
}

//MARK: 接口过滤
extension UserDetailViewController : WXBaseAPIManagerValidator {
    
    func isCorrect(manager:CTNetworkingBaseAPIManager, params:ParamsType?) -> CTNetworkingErrorType.Params {
        if params?.keys.contains("wxId") == false {
            return CTNetworkingErrorType.Params.missingParams
        }
        if params!["wxId"] as! String == "" {
            return CTNetworkingErrorType.Params.missingParams
        }
        return CTNetworkingErrorType.Params.correct
    }
}
