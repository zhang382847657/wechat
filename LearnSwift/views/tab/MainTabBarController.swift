//
//  MainTabBarController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/16.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class MainTabBarController: UITabBarController {
    
    /// 唯一初始化
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 消息
        let messageViewController = MessageViewController()
        createChildController(viewController: messageViewController, title: LanguageHelper.getString(key: LanguageKey.消息.rawValue), image: IconFontType.微信.rawValue, selectedImage: IconFontType.微信_选.rawValue)
        
        // 联系人
        let contactViewController = ContactViewController()
        createChildController(viewController:contactViewController, title: LanguageHelper.getString(key: LanguageKey.通讯录.rawValue), image:IconFontType.通讯录.rawValue, selectedImage: IconFontType.通讯录_选.rawValue)
        
        // 发现
        let findViewController = FindViewController()
        createChildController(viewController: findViewController, title: LanguageHelper.getString(key: LanguageKey.发现.rawValue), image: IconFontType.发现.rawValue, selectedImage: IconFontType.发现_选.rawValue)
        
        // 我的
        let myViewController = MyViewController()
        createChildController(viewController: myViewController, title: LanguageHelper.getString(key: LanguageKey.我.rawValue), image: IconFontType.我.rawValue, selectedImage: IconFontType.我_选.rawValue)
        
        selectedViewController = messageViewController.navigationController
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建子控制器
    ///
    /// - Parameters:
    ///   - viewController: 视图控制器
    ///   - title: 标题
    ///   - image: 正常状态字体图标
    ///   - selectedImage: 被选中字体图标
    func  createChildController(viewController:UIViewController ,title:String , image:String , selectedImage : String ){
        
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = "\(title)"
        
        navigationController.tabBarItem.image = IconFont(code: image, name:kIconFontName, fontSize: 28.0, color: Colors.fontColor.font999).iconImage.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = IconFont(code: selectedImage, name:kIconFontName, fontSize: 28.0, color: Colors.themeColor.main).iconImage.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)], for: UIControlState.normal)
        navigationController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(red: 98/255.0, green: 185/255.0, blue: 0, alpha: 1.0)], for: UIControlState.selected)
        
        self.addChildViewController(navigationController)
    }

}
