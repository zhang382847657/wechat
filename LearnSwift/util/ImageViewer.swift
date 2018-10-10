//
//  ImageViewer.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 图片浏览
class ImageViewer: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    /// 图片URL集合
    private var imageUrls:Array<String> = []
    /// 要跳转到第几个图的下标
    private var jumpToIndex:Int = 0
    /// 当前页面所属的下标
    private var currentIndex:Int = 0
    /// 图片缩放的视图控制器集合
    private var imageViewControllers:[ImageViewController] = []
    /// 将要展示的视图控制器
    private var pengdingViewController:ImageViewController?
    /// 触发图片浏览的视图
    private var imageViews:[UIView] = []
    
    
    
    /// 显示图片浏览组件
    ///
    /// - Parameters:
    ///   - imageUrls: 图片URL集合
    ///   - jumpToIndex: 要跳转到第几个页面的下标
    ///   - fromView: 触发图片浏览的视图
    ///   - viewController: 所在的视图控制器
    public class func show(with imageUrls:Array<String>, jumpToIndex:Int, imageViews:[UIView] = [], viewController:UIViewController = UIViewController.getCurrentViewController()){
        
        let imageViewer = ImageViewer(imageUrls: imageUrls, jumpToIndex: jumpToIndex, imageViews: imageViews)
        viewController.present(imageViewer, animated: false) {
            
        }
        
    }
    
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - imageUrls: 图片URL集合
    ///   - jumpToIndex: 要跳转到第几个页面
    init(imageUrls:Array<String>, jumpToIndex:Int, imageViews:[UIView] = []) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [UIPageViewControllerOptionSpineLocationKey:20])
        
        self.imageUrls = imageUrls
        self.jumpToIndex = jumpToIndex
        self.currentIndex = jumpToIndex
        self.imageViews = imageViews
        
        for (index,value) in self.imageUrls.enumerated() {
            
            if index == jumpToIndex {
                let vc = ImageViewController(url: value, fromView: imageViews[index], isJumpToView: true) {
                    self.dismiss(animated: false, completion: nil)
                }
                imageViewControllers.append(vc)
            }else{
                let vc = ImageViewController(url: value, fromView: imageViews[index], isJumpToView: false)
                imageViewControllers.append(vc)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.black
        dataSource = self
        delegate = self

        let vc:ImageViewController = imageViewControllers[jumpToIndex]
        setViewControllers([vc], direction: .forward, animated: false) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK UIPageViewController DataSource
    
    /// 向左滑动
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let beforeIndex = currentIndex - 1
        if beforeIndex < 0 {
            return nil
        }
        return imageViewControllers[beforeIndex]
    
    }
    
    /// 向右滑动
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let afterIndex = currentIndex + 1
        if afterIndex > imageViewControllers.count - 1 {
            return nil
        }
        return imageViewControllers[afterIndex]
        
    }
    
    
    //MARK: UIPageViewController Delegate
    
    /// 跳转动画开始时触发，利用该方法可以定位将要跳转的界面
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //pendingViewControllers虽然是一个数组，但经测试证明该数组始终只包含一个对象
        pengdingViewController = pendingViewControllers.first as? ImageViewController
    }



    /// 跳转动画完成时触发，配合上面的代理方法可以定位到具体的跳转界面，此方法有利于定位具体的界面位置（childViewControllersArray），便于日后的管理
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed == true {

            for (index,value) in imageViewControllers.enumerated() {
                if self.pengdingViewController == value {
                    pengdingViewController?.imageClickCallBack = {
                        self.pengdingViewController?.closeImageAnimation {
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                    currentIndex = index
                    return
                }
            }
        }


    }

    
    

}

