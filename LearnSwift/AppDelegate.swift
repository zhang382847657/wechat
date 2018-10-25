//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
//        print("aaaaaaa == \(FileOption.image_cache_file)")
//        NetWork.uploadFile(filePath:  "\(FileOption.image_cache_file)/0ad01f61690f85120c94af3788d297d7.jpg", fileType: .image, success: { (data) in
//
//        }) { (error) in
//
//        }
       
        // 创建窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
     
        // 创建视图控制器
        var rootVC:UIViewController?
        if let _ = User.share.token {
            rootVC = MainTabBarController()
        }else {
            rootVC = LoginViewController()
        }
        
        window?.rootViewController =  rootVC //rootViewController  //给窗口一个根视图
        
        // FIXME: 这里不太懂是啥  日后百度
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

