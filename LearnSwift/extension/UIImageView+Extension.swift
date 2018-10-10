//
//  UIImageView+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    
    /// 设置占位图片
    ///
    /// - Parameter isFailed: 是否展示失败图片  默认否
    func setPlaceHolderImage(isFailed:Bool = false) {
        
        self.backgroundColor = UIColor(hex: "#eeeeee")
        self.image = isFailed ? IconFont(code: IconFontType.图片失效.rawValue, fontSize: 15.0, color: UIColor.white).iconImage : IconFont(code: IconFontType.图片.rawValue, fontSize: 15.0, color: UIColor.white).iconImage
    }
    
    
    
    /// 根据网络图片的url获取网络图片的image跟data
    ///
    /// - Parameters:
    ///   - url: 网络图片地址
    ///   - successCallBack: 成功回调
    ///   - failedCallBack: 失败回调
    func setNetWrokUrl(imageUrl url:String?, success successCallBack:@escaping ((UIImage, Data)->Void) = {_,_  in}, failed failedCallBack:@escaping ((Error)->Void) = {_ in}){
        
        guard let url = url else {
            setPlaceHolderImage()
            return
        }
        
        setPlaceHolderImage()
        let pictureType:String = String(url.split(separator: ".").last ?? "jpg")
        
        if let cacheImageData:Data = FileOption.readFile(path: "\(FileOption.image_cache_file)/\(url.md5()).\(pictureType)") as Data?, let cacheDyanmicImage = UIImage(data: cacheImageData) {
            
            self.image = cacheDyanmicImage
            successCallBack(cacheDyanmicImage,cacheImageData)
            
        }else{
            
            NetWork.downloadImageToImageDictionary(url: url, success: { [weak self](image, data) in
                
                if  FileOption.writeFile(documentName: FileOption.image_cache_file, fileName: url.md5() + ".\(pictureType)", data: data as NSData) == true {
                    self?.image = image
                    successCallBack(image,data)
                }else {
                    self?.setPlaceHolderImage(isFailed: true)
                    failedCallBack(FileOption.FileOptionError.writeFileFailed)
                }
                
            }) { [weak self](error) in
                self?.setPlaceHolderImage(isFailed: true)
                failedCallBack(error)
            }
        }
        
        
    }

}
