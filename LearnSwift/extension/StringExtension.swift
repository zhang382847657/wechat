//
//  StringExtension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
extension String {
 
    /// MD5加密
    func md5() -> String {
        
        let cStrl = cString(using: String.Encoding.utf8);
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        
        var md5String = ""
        
        for idx in 0...15 {
            
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            
            md5String.append(obcStrl);
            
        }
        
        free(buffer);
        
        return md5String
    }
    
}
