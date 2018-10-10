//
//  TwoViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/5.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit




class TwoViewController: UIViewController {
    
    
    var view1:UIView!
    
    var view2:UIView!
    
    var view3:UIView!
    
    var view4:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view1 = UIView()
        view1.backgroundColor = UIColor.blue
        
        view2 = UIView()
        view2.backgroundColor = UIColor.brown
        
        view3 = UIView()
        view3.backgroundColor = UIColor.orange
        
        view4 = UIView()
        view4.backgroundColor = UIColor.black
       
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        self.view.addSubview(view4)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        if #available(iOS 11.0, *) {
            view1.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width:screenBounds.width , height: 100)
        } else {
            view1.frame = CGRect(x: 0, y: 0, width:screenBounds.width , height: 100)
        }
        view2.frame = CGRect(origin: CGPoint(x: 0, y: view1.frame.maxY + 10), size: view1.frame.size)
        view3.frame = CGRect(x: 0, y: view2.frame.maxY + 10 , width: 50 , height: 50)
        view4.frame = CGRect(origin: CGPoint(x: view3.frame.maxX , y: view3.frame.origin.y), size:CGSize(width: self.view.frame.width - view3.frame.width, height: view3.frame.height))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
