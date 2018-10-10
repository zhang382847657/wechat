//
//  SettingViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    private let cell_identifier = "cell"
    private let dataSource = [
        ["title":"跟随系统语言"],
        ["title":"简体中文","type":LanguageType.simple_chinese.rawValue],
        ["title":"English","type":LanguageType.english.rawValue]
    ]
    
    private var navigationVC:BaseNavigationController!
    
    /// 显示视图控制器
    class func showVC(viewController:UIViewController, animated:Bool = true){
        let setVC = SettingViewController()
        viewController.present(setVC.navigationVC, animated: animated, completion: nil)
    }
    
    /// 唯一初始化
    required init() {
        super.init(style: .plain)
        self.navigationVC = BaseNavigationController(rootViewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "设置语言"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: LanguageHelper.getString(key: LanguageKey.取消), style: .plain, target: self, action: #selector(cancleClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LanguageHelper.getString(key: LanguageKey.完成), style: .done, target: self, action: #selector(doneClick))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell_identifier)
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 取消点击
    @objc private func cancleClick(){
        
        navigationVC.dismiss(animated: true, completion: nil)
    }
    
    /// 完成点击
    @objc private func doneClick(){
        
        let tabbarController = MainTabBarController()
        tabbarController.selectedIndex = 3
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        let nav:UINavigationController = tabbarController.selectedViewController as! UINavigationController
        let lastVC = nav.viewControllers.last
        
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = tabbarController
            if let lastVC = lastVC {
                SettingViewController.showVC(viewController: lastVC)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath)
        
        let title = dataSource[indexPath.row]["title"]
        let type:String? = dataSource[indexPath.row]["type"]
        let currentLanugage =  LanguageHelper.shareInstance.getCurrentUserLanguage()
        cell.accessoryType = .none
        
        if let type = type {
            if let currentLanugage = currentLanugage {
                if currentLanugage == type {
                    cell.accessoryType = .checkmark
                }
            }
        }else{
            if currentLanugage == nil {
                cell.accessoryType = .checkmark
            }
        }
        
        
        cell.textLabel?.text = title
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            LanguageHelper.shareInstance.resetSystemLanguage()
        }else {
            LanguageHelper.shareInstance.setLanguage(langeuage: dataSource[indexPath.row]["type"]!)
        }

        tableView.reloadData()
    }

}
