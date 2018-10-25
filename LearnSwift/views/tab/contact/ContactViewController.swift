//
//  ContactViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/16.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class ContactViewController: UIViewController
{
    
    /// UITabelView
    @IBOutlet weak var tableView: UITableView!
    /// 搜索控制器
    var searchController:ContactSearchController!
    
    /// 第一种数据源
    var firstDataSource = [
        ["icon":IconFontType.新的朋友.rawValue,"bgColor":"#FF8C00","title":LanguageKey.新的朋友],
        ["icon":IconFontType.群聊.rawValue,"bgColor":"#62b900","title":LanguageKey.群聊],
        ["icon":IconFontType.标签.rawValue,"bgColor":"#4169E1","title":LanguageKey.标签],
        ["icon":IconFontType.公众号.rawValue,"bgColor":"#4169E1","title":LanguageKey.公众号]
    ]
    
    /// 第二种数据源  所有联系人
    var secondDataSource:[[String:Any]] = [] {
        didSet{
            // 对联系人进行排序
            sortContants()
        }
    }
    
    /// 最终通讯录排好序后的数据源 [["key":"A","value":[["imageUrl":"***","name":"Adeo"],["imageUrl":"***","name":"Alice"]]]
    var finalSecondDataSource:[Dictionary<String,Any>] = []
    /// 通讯录字母集合 ["A","B","C"...]
    var sectionTitles:[String] = []
    
    private let cell_contactMenuCell = "ContactMenuCell"
    private let cell_contactUserCell = "ContactUserCell"
    
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
        
    
        // 搜索视图控制器
        searchController = ContactSearchController(tableView: tableView, viewController: self)
        self.definesPresentationContext = true

        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        // 查询联系人列表
        WXApi.contactList (success:{ [weak self](json) in
            self?.secondDataSource = json["dataList"].arrayObject as? [[String:Any]] ?? []
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    /// 对联系人姓名进行排序
    private func sortContants(){
        
        // 最终排序好后的字典  ["A":[["imageUrl":"***","name":"Arise"]],"B":[["imageUrl":"***","name":"Bill"]]]
        var sortedDataSource:Dictionary<String,Array<Dictionary<String,Any>>> = [:]
        for user in secondDataSource {
            
            let name:String = user["name"] as! String
            // 获取名字的首字母
            let firstWord = name.transformToPinyin().prefix(1).uppercased()
            
            if var array  = sortedDataSource[firstWord] {
                array.append(user)
                sortedDataSource[firstWord] = array
            }else {
                sortedDataSource[firstWord] = [user]
            }
        }
        
        sectionTitles = sortedDataSource.keys.sorted()
    
        for value in sectionTitles {
            finalSecondDataSource.append(["key":value,"value":sortedDataSource[value]!])
        }
        
        tableView.reloadData()
    }
    
    
    /// 添加联系人
    @objc private func addContactClick(){
        
    }
   

}


extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + finalSecondDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstDataSource.count
        }else{
            let contants = finalSecondDataSource[section - 1]["value"]! as! Array<Dictionary<String,Any>>
            return contants.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ContactMenuCell = tableView.dequeueReusableCell(withIdentifier: cell_contactMenuCell) as! ContactMenuCell
            
            cell.data = firstDataSource[indexPath.row]
            
            return cell
        }else{
            let cell:ContactUserCell = tableView.dequeueReusableCell(withIdentifier: cell_contactUserCell) as! ContactUserCell
            let contants = finalSecondDataSource[indexPath.section - 1]["value"]! as! Array<Dictionary<String,Any>>
            cell.data = contants[indexPath.row]
            return cell
        }
        
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
   
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        

        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
        header.textLabel?.textColor = Colors.fontColor.font999
        header.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return finalSecondDataSource[section - 1]["key"]! as? String
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contants =  finalSecondDataSource[indexPath.section - 1]["value"]! as! Array<Dictionary<String,Any>>
        let data = contants[indexPath.row]
        
        if indexPath.section != 0 {
            let userDetailVC = UserDetailViewController(wxId: data["wxId"] as! String)
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
    
    
}
