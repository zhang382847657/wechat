//
//  GridImageView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools


/// 9宫格展示图片
/// 如果是1张图，则按照比例显示，如果是4张图，则一行展示2个，其他个数都按照一行3个展示
class GridImageView: UIView {
    
    private var cell_margin:CGFloat = 5.0
    private var cell_paddingH:CGFloat = 0.0
    private var cell_paddingV:CGFloat = 0.0
    private var imageArray:[String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
    }
 
    /// 更新界面
    ///
    /// - Parameters:
    ///   - imageArray: 图片网络地址集合
    ///   - cell_margin: 图片之间的距离  默认5
    ///   - cell_paddingH: 图片水平方向两端的间距  默认0
    ///   - cell_paddingV: 图片垂直方向两端的间距  默认0
    func updateUIWith(imageArray:[String], cell_margin:CGFloat = 5.0, cell_paddingH:CGFloat = 0, cell_paddingV:CGFloat = 0) {
        
        self.imageArray = imageArray
        self.cell_margin = cell_margin
        self.cell_paddingH = cell_paddingH
        self.cell_paddingV = cell_paddingV
        
        // 先清除所有的子视图
        for v in self.subviews{
            v.removeFromSuperview()
        }
        
        
        if self.imageArray.count == 0 { //如果没有任何图片
            return
        }else if self.imageArray.count == 1 { //如果只有一张图
            
            let imageView:UIImageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            /////添加tapGuestureRecognizer手势
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTap))
            imageView.addGestureRecognizer(tapGR)
            self.addSubview(imageView)
            
            let leftAnchor =  imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
            let topAnchor =  imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            let bottomAnchor =  imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            let widthAnchor =  imageView.widthAnchor.constraint(equalToConstant: 70)
            let heightAnchor = imageView.heightAnchor.constraint(equalToConstant: 70)
            
            NSLayoutConstraint.activate([leftAnchor, topAnchor, bottomAnchor, widthAnchor, heightAnchor])
            
            
            imageView.setImage(withUrl: self.imageArray.first!, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, success: { (image, data) in
                
                // 先删除之前宽高的约束
                NSLayoutConstraint.deactivate([heightAnchor,widthAnchor])
                
                // 最终宽高的约束
                var finalWidthAnchor:NSLayoutConstraint!
                var finalHeightAnchor:NSLayoutConstraint!


                // 单张图片显示的最大区域
                let maxSize:CGSize = CGSize(width: self.bounds.width, height: self.bounds.width)

                if image.size.width < maxSize.width && image.size.height < maxSize.height { //如果图片真实的大小都小于最大的尺寸

                    finalHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: image.size.height)
                    finalWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: image.size.width)


                }else{
                    if image.size.width > image.size.height { //是个扁图
                        finalWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: maxSize.width)
                        finalHeightAnchor = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: image.size.height / image.size.width)
                    }else { //是个长图
                        finalHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: maxSize.width)
                        finalWidthAnchor = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
                    }
                }


                NSLayoutConstraint.activate([finalWidthAnchor,finalHeightAnchor])
                
            }) { (error) in
                
            }
            
            return
            
        }else if self.imageArray.count == 4 { //如果是4张图
            
            // 给图片数组里面插入两个元素，让图片由4张变成6张，这样可以按照正常的9宫格去布局
            self.imageArray.insert("tmp", at: 2)
            self.imageArray.insert("tmp", at: 5)

        }else if self.imageArray.count == 2 { //如果是2张图
            // 给图片数组里面插入一个元素，组成一行
            self.imageArray.insert("tmp", at: 2)
        }
        
        
        var lastView:UIImageView? = nil
        for (index,value) in self.imageArray.enumerated() {
            
            let imageView:UIImageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)
            
            if value == "tmp" {
                imageView.backgroundColor = UIColor.clear
            }else {
                imageView.isUserInteractionEnabled = true
                /////添加tapGuestureRecognizer手势
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTap))
                imageView.addGestureRecognizer(tapGR)
                imageView.setImage(withUrl: value, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
            }
            
            
            var leftAchor:NSLayoutConstraint! , topAchor:NSLayoutConstraint!
            
            
            if let lastView = lastView{
                
                if index % 3 == 0 {
                    leftAchor = imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
                    topAchor = imageView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: cell_margin)
                }else{
                    leftAchor = imageView.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: cell_margin)
                    topAchor = imageView.topAnchor.constraint(equalTo: lastView.topAnchor, constant: 0)
                }
                
                if (index + 1) % 3 == 0 {
                    let rightAchor = imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -cell_paddingH)
                    NSLayoutConstraint.activate([rightAchor])
                }
                
                let widthAchor = imageView.widthAnchor.constraint(equalTo: lastView.widthAnchor)
                NSLayoutConstraint.activate([widthAchor])
                
            }else{
                leftAchor = imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
                topAchor = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: cell_paddingV)
            }
            
            
            let heightAchor = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            
            NSLayoutConstraint.activate([leftAchor,topAchor,heightAchor])
            
            lastView = imageView
        }
        
        if let lastView = lastView {
            NSLayoutConstraint.activate([lastView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: cell_paddingV)])
        }
        
        
        
    }
    

    
    /// 图片点击
    @objc private func imageTap(sender:UITapGestureRecognizer){
        
        // 最终要展示图片的视图数组和图片Url数组
        var finalImageViews:[UIView] = []
        var finalImageArray:[String] = []

        // 过滤掉占位图视图以及占位url字符串
        for (index,value) in self.subviews.enumerated() {
            if imageArray[index] != "tmp" {
                finalImageViews.append(value)
                finalImageArray.append(imageArray[index])
            }
            
        }
        
        // 获得当前图片在图片数组的下标
        var jumpToIndex:Int = 0
        for (index,value) in finalImageViews.enumerated() {
            if value == sender.view! {
                jumpToIndex = index
                break
            }
        }
        
        // 显示图片浏览的组件
        ImageViewer.show(with: finalImageArray, jumpToIndex: jumpToIndex, imageViews:finalImageViews)
        
    }


   
}
