//
//  NetWork.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class NetWork: NSObject {
    
    
    /// 网络请求失败
    ///
    /// - EmptyProperty: 空属性
    /// - InvalidValue: 未知错误
    /// - ImageUrlFormat: 图片URL格式错误
    /// - ImageCannotToData: image转Data失败
    enum NetWorkError: Error {
        case EmptyProperty
        case InvalidValue
        case ImageUrlFormat
        case ImageCannotToData
    }
    
    
    /// GET请求
    ///
    /// - Parameters:
    ///   - url: url
    ///   - param: 参数
    ///   - success: 成功回调
    ///   - failed: 失败回调
    public class func get(url:String, param:Dictionary<String,Any>? = nil, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        
        var fianlUrl:String = url
        if let param = param {
            fianlUrl += "?"
            for (key,value) in param {
               fianlUrl += "\(key)=\(value)&"
            }
        }
        
        httpSync(requestURL: fianlUrl, postString: nil, method: "GET", success: success, failed: failed)
    }
    
    
    /// POST请求
    ///
    /// - Parameters:
    ///   - url: url
    ///   - param: 参数
    ///   - success: 成功回调
    ///   - failed: 失败回调
    public class func post(url:String, param:Dictionary<String,Any>? = nil, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil){
        
        var postString:String?
        if let param = param {
            postString = JSON(param).rawString([.castNilToNSNull : true])
        }
        
        
        httpSync(requestURL: url, postString: postString, method: "POST", success: success, failed: failed)
    }
    
    
    private class func httpSync(requestURL:String, postString:String?, method:String, success:@escaping ((JSON)->Void), failed:((Error)->Void)? = nil) {
        
        var request = URLRequest(url: URL(string:"\(api_url)\(requestURL)")!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        if let token = User.share.token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = method
        
        if let ps = postString {
            request.httpBody =  ps.data(using: String.Encoding.utf8)
        }
        
//        let semaphore = DispatchSemaphore(value:0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // 切到主线程
            DispatchQueue.main.async() { () -> Void in
                
                guard let data = data, error == nil else {
                    
                    if let failed = failed {
                        failed(error!)
                    }
                    return
                }
                
                do {
                    
                    let result = try JSON(data: data)
                    
                    if result["result"].stringValue == "ok" {
                        
                        success(result["data"])
                        print(result["data"])
                        
                    }else {
                        switch result["rescode"].intValue {
                        case 202 :
                            print("未登录")
                        case 203 :
                            print("登录过期")
                            User.share.clearUserInfo()
                            
                        default :
                            if let failed = failed {
                                failed(NetWorkError.InvalidValue)
                            }
                            print("其他原因 == \(result["msg"].stringValue)")
                        }
                    }
                    
                    
                    
                } catch let jsonError {
                    
                    if let failed = failed {
                        failed(jsonError)
                    }
                }
               
            }
    
            
//            semaphore.signal()
        }
        
        task.resume()
        
//        _ = semaphore.wait(timeout: .distantFuture)
    

        
    }
    
    
    /// 加载网络图片
    ///
    /// - Parameters:
    ///   - url: 图片地址
    ///   - success: 成功回调
    ///   - failed: 失败回调
    public class func downloadImageToImageDictionary(url: String, success:@escaping ((UIImage, Data)->Void), failed:((Error)->Void)? = nil){
        
        if url.hasPrefix("http://") && (url.hasSuffix(".png")||url.hasSuffix(".jpg")) == false {
            if let failed = failed {
                failed(NetWorkError.ImageUrlFormat)
            }
            return
        }
       
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                if let failed = failed {
                    failed(error!)
                }
                return
            }
            
            DispatchQueue.main.async() { () -> Void in
                
                if let image = UIImage(data: data) {
                     success(image,data)
                }else{
                    if let failed = failed {
                        failed(NetWorkError.ImageCannotToData)
                    }
                }
               
            }
            
            }.resume()
    }

}
