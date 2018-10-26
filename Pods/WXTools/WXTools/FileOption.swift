//
//  FileOption.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

public class FileOption: NSObject {
    

    /// 文件操作异常
    ///
    /// - createDocumenFailed: 创建文件夹失败
    /// - readFileFailed: 读取文件失败
    /// - writeFileFailed: 写入文件失败
    public enum FileOptionError: Error {
        case createDocumenFailed
        case readFileFailed
        case writeFileFailed
    }
    
    /// 写入文件
    ///
    /// - Parameters:
    ///   - documentName: 文件所在文件夹的路径
    ///   - fileName: 文件名
    ///   - data: 文件data流
    /// - Returns: 是否写入成功
    public class func writeFile(documentName:String, fileName:String , data:NSData) -> Bool {
        
        if self.isExistsFile(path: documentName) {
            return data.write(toFile: NSURL(fileURLWithPath: "\(documentName)/\(fileName)").path!, atomically: true)
        }else{
            return false
        }
    }
    
    
    /// 读取文件
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 返回文件Data流对象
    public class func readFile(path:String) -> NSData?{
       
        do{
            return try NSData(contentsOfFile: path, options: NSData.ReadingOptions.uncached)
        }catch{
            print("文件读取失败")
            return nil
        }
        
    }
    

    /// 检测文件夹是否存在，不存在则创建一个文件夹
    ///
    /// - Parameter path: 文件夹的路径
    /// - Returns: 文件夹是否存在
    public class func isExistsFile(path : String) -> Bool {
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath:path)
        if exist {
            return true
        }else{
            //不存在则创建一个文件夹
            do{
                try fileManager.createDirectory(at: NSURL(fileURLWithPath:path, isDirectory: true) as URL, withIntermediateDirectories: true, attributes: nil)
            }catch{
                return false
            }
            return true
        }
    }

    
}
