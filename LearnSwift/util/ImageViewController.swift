//
//  ImageViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    /// 图片
    private var imageView:UIImageView!
    /// 图片网络地址
    private var imageUrl:String!
    /// 从哪个视图过渡过来
    private var fromView:UIView!
    /// 是否是最开始要展示的图片
    private var isJumpToView:Bool!
    /// 图片点击回调
    var imageClickCallBack:(()->Void)?
    
    
    
    /// 唯一初始化
    ///
    /// - Parameters:
    ///   - url: 图片URL
    ///   - fromView: 从哪个视图过渡过来
    ///   - isJumpToView: 是否是最开始要展示的图片  默认不是，如果是的话有一个动画效果展开到最大
    ///   - imageClick: 图片点击回调
    required init(url:String, fromView:UIView, isJumpToView:Bool = false, imageClick:(()->Void)? = nil) {
        
        super.init(nibName: "ImageViewController", bundle: nil)
        
        self.imageUrl = url
        self.fromView = fromView
        self.isJumpToView = isJumpToView
        self.imageClickCallBack = imageClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
        
        // 设置图片单击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageClick))
        imageView.addGestureRecognizer(tap)
        
        // 设置图片双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleImageClick))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        
        // 优先检测doubleTap,若doubleTap检测不到，或检测失败，则检测tap,检测成功后，触发方法
        tap.require(toFail: doubleTap)
       
        // 加载网络图片
        imageView.setNetWrokUrl(imageUrl: imageUrl, success: { [weak self] (image, data) in
            
            if let weakSelf = self {
                
                // 设置图片的宽，图片的宽最大不能超过屏幕的宽，同时高度等比显示
                let finalImageWidth = image.size.width > weakSelf.scrollView.bounds.width ? weakSelf.scrollView.bounds.width : image.size.width
                
                // 得出图片最终宽高的位置坐标
                var frame = weakSelf.imageView.frame
                frame.size = CGSize(width: finalImageWidth , height: finalImageWidth * image.size.height / image.size.width)
                
                // 设置滚动视图的内容大小跟图片最终的大小一致
                weakSelf.scrollView.contentSize = frame.size
                
                if weakSelf.isJumpToView == true { // 如果当前图片是默认展示的页面，要做一个从原来视图逐渐放大显示到屏幕正中间的动画效果

                    // 通过坐标转换，得到一开始图片的位置在当前scrollView坐标系中的位置
                    let startRect = weakSelf.fromView.convert(weakSelf.fromView.bounds, to: weakSelf.scrollView)
                    weakSelf.imageView.frame = startRect

                    //FIXME: 不知道为什么，这里必须要给个延迟才能触发动画效果
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {

                        //添加动画效果，让图片有原来的位置挪到屏幕中心点，并且按照图片原本的尺寸展示
                        UIView.animate(withDuration: 0.1, animations: {
                            weakSelf.imageView.frame = frame
                            weakSelf.imageView.center = CGPoint(x: weakSelf.scrollView.bounds.width / 2.0, y: weakSelf.scrollView.bounds.height / 2.0)

                        }, completion: nil)
                    })


                }else{
                    
                    weakSelf.imageView.frame = frame
                    
                }
                
            }
            
        }) { (error) in
            
        }
        
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 如果当前图片不是优先展示的图片，则把图片直接在中心显示
        if isJumpToView == false{
            imageView.center = CGPoint(x: scrollView.bounds.width / 2.0, y: scrollView.bounds.height / 2.0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    /// 图片点击
    @objc private func imageClick(){
        
        if isJumpToView == true { // 如果是第一个展示的页面，图片点击时，先调用关闭的动画效果，再把回调返回
            closeImageAnimation { [weak self] in
                if let icb = self?.imageClickCallBack {
                    icb()
                }
            }
        }else{ // 否则直接把点击图片回调返回，让用户手动调用关闭图片的动画效果
            if let icb = imageClickCallBack {
                icb()
            }
        }
    }
    
    /// 图片双击
    @objc  private func doubleImageClick(tap:UIGestureRecognizer){
       
        let newScale:CGFloat = scrollView.zoomScale > 1 ? 1.0 : 2.0
        let zoomRect:CGRect = zoomRectForScale(scale: newScale, withCenter: tap.location(in: tap.view!))
        scrollView.zoom(to: zoomRect, animated: true)
        
    }
    
    
    /// 计算图片缩放后的位置坐标
    ///
    /// - Parameters:
    ///   - scale: 缩放系数
    ///   - center: 图片的中心点
    /// - Returns: 返回缩放后的位置坐标
    private func zoomRectForScale(scale:CGFloat, withCenter center:CGPoint) -> CGRect {
        let zoomHeight = scrollView.frame.size.height / scale
        let zoomWidth = scrollView.frame.size.width / scale
        let zoomX = center.x - zoomWidth / 2.0
        let zoomY = center.y - zoomHeight / 2.0
        return CGRect(x: zoomX , y: zoomY, width: zoomWidth, height: zoomHeight)
        
    }

    
   
    
    
    /// 图片收起动画效果
    ///
    /// - Parameter finish: 动画结束的回调
    func closeImageAnimation(finish:@escaping (()->Void)){
       
        let endRect = fromView.convert(fromView.bounds, to: scrollView)
        
        //动画效果
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.frame = endRect
        }) { (isFinish) in
            finish()
        }
        
        
    }


    //MARK: UIScroll Delegate
    /// 当前需要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放完毕的生命周期
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        // 这里让图片放大之后，始终让图片居中
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }

}
