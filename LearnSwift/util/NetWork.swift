//
//  NetWork.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    
    /// 文件上传类型
    ///
    /// - image: 图片类型
    /// - video: 视频类型
    /// - audio: 音频类型
    enum FileUploadType: String {
        case image = "image/*"
        case video = "video/*"
        case audio = "audio/*"
    }
    
    /// 设置分隔线
    static let boundary = String(format: "boundary.%08x%08x", arc4random(), arc4random())
    
    
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
    
    
    /// 上传文件
    ///
    /// - Parameters:
    ///   - fileData: 文件Data数据
    ///   - fileName: 文件名
    ///   - fileType: 文件类型
    ///   - success: 成功回调
    ///   - failed: 失败回调
    public class func uploadFile(fileData:Data, fileName:String, fileType:FileUploadType, success:@escaping ((String)->Void), failed:((Error)->Void)? = nil){
        
        //上传地址
        let url = URL(string: "\(api_url)upload")
        //请求
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.setValue("multipart/form-data; boundary=\(NetWork.boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("text/html,application/json,text/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        if let token = User.share.token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // 从这里开始构造请求体
        // 存放参数的数组，后续好转成字符串，也就是请求体
        let body  = NSMutableArray()
        // 拼接参数和boundary的临时变量
        var fileTmpStr = ""
        //设置为POST请求
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=----\(boundary)", forHTTPHeaderField: "Content-Type")
        //            //拆分字典,parameter是其中一项，将key与value变成字符串
        //            for parameter in parameters {
        //                // 将boundary和parameter组装在一起
        //                fileTmpStr = "------\(boundary)\r\nContent-Disposition: form-data; name=\"\(parameter.0)\"\r\n\r\n\(parameter.1)\r\n"
        //                body.add(fileTmpStr)
        //            }
        print("上传文件的名字 == \(fileName)")
        // 将文件名和boundary组装在一起
        fileTmpStr = "------\(boundary)\r\nContent-Disposition: form-data; name=\"inputFile\"; filename=\"\(fileName)\"\r\n"
        body.add(fileTmpStr)
        // 文件类型是图片，png、jpeg随意
        fileTmpStr = "Content-Type: \(fileType)\r\n\r\n"
        body.add(fileTmpStr)
        // 将body里的内容转成字符串
        let parameterStr = body.componentsJoined(by: "")
        // UTF8转码，防止汉字符号引起的非法网址
        var parameterData = parameterStr.data(using: String.Encoding.utf8)!
        // 将图片追加进parameterData
        parameterData.append(fileData)
        // 将boundary结束部分追加进parameterData
        parameterData.append("\r\n------\(boundary)--".data(using: String.Encoding.utf8)!)
        // 设置请求体
        request.httpBody = parameterData
        //默认session配置
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //发起请求
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //上传完毕后
            if error != nil{
                print(error!)
                failed?(error!)
            }else{
                
                do {
                    
                    let result = try JSON(data: data!)
                    
                    if result["result"].stringValue == "ok" {
                        
                        success(result["data","filePath"].stringValue)
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
        }
        //请求开始
        dataTask.resume()
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
    
        }
        
        task.resume()
        
    }

}
