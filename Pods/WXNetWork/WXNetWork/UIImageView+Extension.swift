//
//  UIImageView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import AlamofireImage

public extension UIImageView {
    
    
    /// 根据网络图片的url获取网络图片的image跟data
    ///
    /// - Parameters:
    ///   - url: 网络图片地址
    ///   - successCallBack: 成功回调
    ///   - failedCallBack: 失败回调
    public func setImage(withUrl url:String?,  placeholderImage:UIImage?, failedImage:UIImage?, success successCallBack:((UIImage, Data)->Void)? = {_,_  in}, failed failedCallBack:((Error)->Void)? = {_ in}){
        
        guard let url = url else {
            //如果图片地址为空，则展示失败的图片
            self.image = failedImage
            return
        }
        
        self.af_setImage(withURL: URL(string: url)!, placeholderImage: placeholderImage) { (response) in
        
            if let error = response.error {
                self.image = failedImage
                failedCallBack?(error)
                return
            }else {
                successCallBack?(response.result.value!, UIImagePNGRepresentation(response.result.value!)!)
            }
            
        }
        
    }

}
