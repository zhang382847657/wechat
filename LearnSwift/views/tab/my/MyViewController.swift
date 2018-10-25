//
//  MyViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class MyViewController: UITableViewController {
    
    /// 数据源
    private var dataSource = [
        [
            ["iconfont":IconFontType.钱包.rawValue,"iconColor":"#87CEFA","title":LanguageKey.钱包]
        ],
        [
            ["iconImage":"shoucang","title":LanguageKey.收藏],
            ["iconfont":IconFontType.相册.rawValue,"iconColor":"#87CEFA","title":LanguageKey.相册],
            ["iconImage":"kabao","title":LanguageKey.卡包],
            ["iconfont":IconFontType.表情_2.rawValue,"iconColor":"#FFD700","title":LanguageKey.表情]
        ],
        [
            ["iconfont":IconFontType.设置.rawValue,"iconColor":"#87CEFA","title":LanguageKey.设置]
        ],
    ]
    
    private let cell_myInfoCell = "MyInfoCell"
    private let cell_menuCell = "MenuCell"
    
    
    /// 唯一初始化
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LanguageHelper.getString(key: LanguageKey.我.rawValue)
        
        tableView.register(UINib(nibName: "MyInfoCell", bundle: nil), forCellReuseIdentifier: cell_myInfoCell)
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: cell_menuCell)
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.sectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0.1
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return dataSource[section-1].count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:MyInfoCell = tableView.dequeueReusableCell(withIdentifier: cell_myInfoCell) as! MyInfoCell
            return cell
        }else {
            let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: cell_menuCell) as! MenuCell
            cell.data = dataSource[indexPath.section-1][indexPath.row]
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            if indexPath.row == 0 { //设置
                SettingViewController.showVC(viewController: self)
            }
        default:
            break
        }
    }
 

}
