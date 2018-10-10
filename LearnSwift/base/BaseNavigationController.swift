//
//  BaseNavigationController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = Colors.themeColor.main2
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }

   

}
