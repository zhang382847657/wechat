//
//  LoginViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit


/// 登录
class LoginViewController: UIViewController {
    
    /// 微信号输入框
    @IBOutlet weak var wxNumberTF: UITextField!
    /// 密码输入框
    @IBOutlet weak var pwdTF: UITextField!
    
    
    required init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 登录
    @IBAction func loginClick(_ sender: UIButton) {
        
        guard let wxId = wxNumberTF.text else {
            print("请输入微信号")
            return
        }
        
        guard let password = pwdTF.text else {
            print("请输入密码")
            return
        }
        
        WXApi.login(wxId: wxId, password: password, success: ({ (json) in
            User.share.saveUserLoginInfo(json: json)
            UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
        }))
    }
    

}
