//
//  PlaceholderViewProtocol.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/11/12.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 占位视图协议
public protocol PlaceholderView  {
    
    /// 占位视图
    var placeholderView:UIView {get set}
}



// MARK: - 视图控制器扩展占位图协议
public extension PlaceholderView where Self : UIViewController {
    
    
    /// 显示占位图
    public func showPlaceholderView() {
        
        
        // 添加tag值，方便隐藏占位图的时候可以找到
        placeholderView.tag = 1024
    
        
        if self .isKind(of: UITableViewController.self) {

            let tableViewController:UITableViewController = self as! UITableViewController
            placeholderView.frame = tableViewController.tableView.bounds
            tableViewController.tableView.backgroundView = placeholderView

        }else if self .isKind(of: UICollectionViewController.self){

            let collectionViewController:UICollectionViewController = self as! UICollectionViewController
            guard let collectionView = collectionViewController.collectionView else {
                return
            }
            placeholderView.frame = collectionView.bounds
            collectionView.backgroundView = placeholderView

        }else {
            placeholderView.frame = view.bounds
            view.addSubview(placeholderView)
        }
    
        
    }
    
    
    /// 隐藏占位图
    public func hidenPlaceholderView() {
        view.subviews.filter({ $0.tag == 1024 }).first?.removeFromSuperview()
    }
    
}
