//
//  FindViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class FindViewController: UITableViewController {

    /// 数据源
    private var dataSource = [
        [
            ["iconImage":"pengyouquan","title":LanguageKey.朋友圈],
        ],
        [
            ["iconfont":IconFontType.扫一扫.rawValue,"iconColor":"#87CEFA","title":LanguageKey.扫一扫],
            ["iconImage":"yaoyiyao","title":LanguageKey.摇一摇],
        ],
        [
            ["iconImage":"kanyikan","title":LanguageKey.看一看],
            ["iconImage":"souyisou","title":LanguageKey.搜一搜],
        ],
        [
            ["iconImage":"fujinderen","title":LanguageKey.附近的人],
            ["iconImage":"piaoliuping","title":LanguageKey.漂流瓶],
        ],
        [
            ["iconfont":IconFontType.购物.rawValue,"iconColor":"#87CEFA","title":LanguageKey.购物],
            ["iconImage":"youxi","title":LanguageKey.游戏],
        ],
        [
            ["iconfont":IconFontType.小程序.rawValue,"iconColor":"#87CEFA","title":LanguageKey.小程序]
        ],
    ]
    
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
        
        self.navigationItem.title = LanguageHelper.getString(key: LanguageKey.发现.rawValue)
        
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
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: cell_menuCell) as! MenuCell
        cell.data = dataSource[indexPath.section][indexPath.row]
        return cell
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let friendCircleVC = WeixinViewController()
            self.navigationController?.pushViewController(friendCircleVC, animated: true)
        }else{
            let vc = SportsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
