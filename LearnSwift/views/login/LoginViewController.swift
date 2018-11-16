//
//  LoginViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import CTNetworkingSwift
import Alamofire
import SwiftyJSON


/// 登录
class LoginViewController: UIViewController {
    
    /// 微信号输入框
    @IBOutlet weak var wxNumberTF: UITextField!
    /// 密码输入框
    @IBOutlet weak var pwdTF: UITextField!
    /// 登录Reform
    private var loginReform:LoginReform = LoginReform()
    /// 登录ApiManager
    private lazy var wxLoginApiManager:WXLoginApiManager = {
       let m = WXLoginApiManager.init()
        m.delegate = self
        m.paramSource = self
        m.validator = self
        return m
    }()

    
    
    /// 唯一初始化
    required init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 登录
    @IBAction func loginClick(_ sender: UIButton) {
        
        guard let _ = wxNumberTF.text else {
            print("请输入微信号")
            return
        }
        
        guard let _ = pwdTF.text else {
            print("请输入密码")
            return
        }
        
        //请求登录
        wxLoginApiManager.loadData()
    }
    

}

extension LoginViewController : CTNetworkingBaseAPIManagerParamSource {
    
    func params(for apiManager:CTNetworkingBaseAPIManager) -> ParamsType? {
        return ["wxId":wxNumberTF.text!,"password":pwdTF.text!]
    }
}

extension LoginViewController : CTNetworkingBaseAPIManagerCallbackDelegate {
    
    func requestDidSuccess(_ apiManager:CTNetworkingBaseAPIManager){
        let data:JSON? = apiManager.fetch(reformer: loginReform) as? JSON
        guard let userInfo = data else {
            return
        }
        User.share.saveUserLoginInfo(json: userInfo)
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
    }
    
    func requestDidFailed(_ apiManager:CTNetworkingBaseAPIManager){
        print("请求失败")
    }

}

extension LoginViewController : WXBaseAPIManagerValidator {
    
    func isCorrect(manager:CTNetworkingBaseAPIManager, params:ParamsType?) -> CTNetworkingErrorType.Params {
        guard let params = params else {
            return .missingParams
        }
        
        if params.keys.contains("wxId") == false{
            return .missingParams
        }
        
        if params["wxId"] as! String == "" {
            return .missingParams
        }
        
        if params.keys.contains("password") == false {
            return .missingParams
        }
        
        if params["password"] as! String == "" {
            return .missingParams
        }
        
        return .correct
        
    }
}

