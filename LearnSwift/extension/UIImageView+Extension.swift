//
//  UIImageView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit
import WXTools

extension UIImageView {
    
    /// 根据网络图片的url获取网络图片的image跟data
    ///
    /// - Parameters:
    ///   - url: 网络图片地址
    ///   - successCallBack: 成功回调
    ///   - failedCallBack: 失败回调
    func setNetWrokUrl(imageUrl url:String?, success successCallBack:((UIImage, Data)->Void)? = {_,_  in}, failed failedCallBack:((Error)->Void)? = {_ in}){
        

        //先展示占位图
        self.backgroundColor = Colors.backgroundColor.coloree
        setImageWith(placeHolderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage)
        
        guard let url = url else {
            //如果图片地址为空，则展示失败的图片
            setImageWith(placeHolderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage, isFailed: true)
            return
        }
        
        //图片类型
        let pictureType:String = String(url.split(separator: ".").last ?? "jpg")
        //图片加密后的名字
        let imageFileName = "\(image_cache_file)/\(url.md5()).\(pictureType)"
        
        if let cacheImageData:Data = FileOption.readFile(path: imageFileName) as Data?, let cacheDyanmicImage = UIImage(data: cacheImageData) {
            self.image = cacheDyanmicImage
            successCallBack?(cacheDyanmicImage,cacheImageData)
            
        }else{
            
            NetWork.downloadImageToImageDictionary(url: url, success: { [weak self](image, data) in
                
                //磁盘中缓存该图片
                let _ = FileOption.writeFile(documentName: image_cache_file, fileName: url.md5() + ".\(pictureType)", data: data as NSData)
                //显示图片
                self?.image = image
                //返回成功的回调
                successCallBack?(image,data)
               
                
            }) { [weak self](error) in
                
                //展示图片加载失败的图
                self?.setImageWith(placeHolderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: UIColor.white).iconImage, isFailed: true)
                //返回失败的回调
                failedCallBack?(error)
            }
        }
        
        
    }

}
