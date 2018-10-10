//
//  VipController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/4.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class VipController: UIViewController {
    
    private let label:UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.red
        
    
    
        
        label.backgroundColor = UIColor.yellow
        label.text = "王殿明是傻逼"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        self.view.addSubview(label)
        
        
    
       
    }
    
    override func viewDidLayoutSubviews() {
        
//        label.center = self.view.center
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
