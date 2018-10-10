//
//  UserDetailViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class UserDetailViewController: UITableViewController {
    
    /// 数据源
    private var dataSource:[[[String:Any]]] = []
    
    /// 微信号
    private var wxId:String!
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconFont(code: IconFontType.更多.rawValue, fontSize: 20, color: UIColor.white).iconImage, style: .plain, target: self, action: #selector(moreClick))
        

        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.sectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0.1
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
       
        tableView.register( UINib(nibName: "UserDetailHeaderCell", bundle: nil), forCellReuseIdentifier: cell_userDetailHeaderCell)
        tableView.register( UINib(nibName: "UserDetailDefaultCell", bundle: nil), forCellReuseIdentifier: cell_userDetailDefaultCell)
        tableView.register(UINib(nibName: "UserDetailPhotoCell", bundle: nil), forCellReuseIdentifier: cell_userDetailPhotoCell)
        
        
        WXApi.queryUserInfo(wxId: wxId, success: { (json) in
            
            let headPicture = json["headPicture"].string
            let name = json["name"].stringValue
            let sex = json["sex"].intValue
            let phone = json["phone"].stringValue
            let province = json["province"].string ?? ""
            let city = json["city"].string ?? ""
            let district = json["district"].string ?? ""
            let remarkName = json["remarkName"].string
            
            let address = "\(province) \(city) \(district)"
            
            self.dataSource = [
                [
                    ["imageUrl":headPicture,"name":name,"weixinNumber":self.wxId,"remarkName":remarkName,"sex":sex]
                ],
                [
                    ["title":"设置备注和标签","showArrow":true],
                    ["title":"电话号码","subTitle":phone,"showArrow":false]
                ],
                [
                    ["title":"地区","subTitle":address,"showArrow":false],
                    ["title":"个人相册","imageUrls":["https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1555162835,2120770057&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3972446805,2469332184&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1265907631,191003867&fm=26&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3222719360,565415155&fm=27&gp=0.jpg"],"showArrow":true],
                    ["title":"更多","showArrow":true]
                ]
            ]
            
            self.tableView.reloadData()
            
        }, failed: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 更多点击
    @objc private func moreClick(){
        
    }

    // MARK: - Table view data source

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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
