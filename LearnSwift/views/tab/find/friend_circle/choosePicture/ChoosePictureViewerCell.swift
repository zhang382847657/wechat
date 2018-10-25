//
//  ChoosePictureViewerCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/12.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class ChoosePictureViewerCell: UICollectionViewCell, UIScrollViewDelegate {

    // 滚动视图
    private var scrollView: UIScrollView!
    // 图片
    private var imageView:UIImageView!
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.backgroundColor = (Int(arc4random() % 10) + 1) % 2 == 0 ? UIColor.blue :UIColor.brown
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        // 设置图片单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleImageClick))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(singleTap)
        
        // 设置图片双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleImageClick))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        singleTap.require(toFail: doubleTap)
        imageView.addGestureRecognizer(doubleTap)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 设置UI
    func setUIWith(image:UIImage) {
        
        scrollView.delegate = self
        imageView.image = image
    }
    
    override func layoutSubviews() {
        
        scrollView.frame = self.bounds
        
        guard let image = imageView?.image else {
            return
        }
        
        //设置imageView的尺寸确保一屏能显示的下
        imageView.frame.size = scaleSize(size: image.size)
        //imageView居中
        imageView.center = scrollView.center
        
    }
    
    /// 获取imageView的缩放尺寸（确保首次显示是可以完整显示整张图片）
    private func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/self.bounds.width
        let heightRatio = height/self.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
    /// 图片单击
    @objc private func singleImageClick(tap:UIGestureRecognizer){
       
        if let nav = UIViewController.getCurrentViewController().navigationController {
            nav.setNavigationBarHidden(!nav.isNavigationBarHidden, animated: true)
        }
    }
    
    /// 图片双击
    @objc  private func doubleImageClick(tap:UIGestureRecognizer){
        UIViewController.getCurrentViewController().navigationController?.setNavigationBarHidden(true, animated: true)
        
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
    
    /// 计算图片缩放后的位置坐标
    ///
    /// - Parameters:
    ///   - scale: 缩放系数
    ///   - center: 图片的中心点
    /// - Returns: 返回缩放后的位置坐标
    private func zoomRectForScale(scale:CGFloat, withCenter center:CGPoint, scrollView:UIScrollView) -> CGRect {
        let zoomHeight = scrollView.frame.size.height / scale
        let zoomWidth = scrollView.frame.size.width / scale
        let zoomX = center.x - zoomWidth / 2.0
        let zoomY = center.y - zoomHeight / 2.0
        return CGRect(x: zoomX , y: zoomY, width: zoomWidth, height: zoomHeight)
        
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
