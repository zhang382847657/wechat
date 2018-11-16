//
//  GroupImageView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import WXNetWork

/// 可以显示群头像的UIImageView  也可以显示一张图
class GroupImageView: UIImageView {
    
    /// 图片链接
    var imageUrls:Array<String> = [] {
        didSet{
            setupImage()
        }
    }
    
    /// 每个图片的间隙
    private let space:CGFloat = 2.0
    /// 图片的位置信息
    private var imageReacts:Array<CGRect> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setupImage() {
        
        // 最终所有的图片的资源
        var images:Array<UIImage> = []
        // 任务队列
        let queue = DispatchQueue(label: "requestHandler")
        // 分组
        let group = DispatchGroup()
        
        weak var weakSelf =  self
        
        // 循环开始去下载图片
        for url in imageUrls {
            
            queue.async(group: group) {
                
                let sema = DispatchSemaphore(value: 0)
                
                
                weakSelf?.setImage(withUrl: url, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, success: { (image, data) in
                    
                    weakSelf?.image = nil
                    images.append(image)
                    //信号量+1这时就可以触发这个任务结束了
                    sema.signal()
                    
                }, failed: { (error) in
                    
                    //网络调用失败也需要+1，否则会永远阻塞了
                    weakSelf?.image = nil
                    images.append(UIImage(named: "failedHolder")!)
                    sema.signal()
                    
                })
                
                
                //异步调用返回前，就会一直阻塞在这
                sema.wait()
            }
        }
        
        
        //全部调用完成后回到主线程,再更新UI
        group.notify(queue: DispatchQueue.main, execute: {[weak self] in
            self?.drawImages(images: images)
        })
        
    }

    

    private func drawImages(images:Array<UIImage>){
        // 计算图片的位置  不同数量的图片，位置排列也不一样
        switch images.count {
        case 0:
            break
        case 1:
            imageReacts = [self.bounds]
        case 2:
            break
        case 3:
            let cell_width = (self.bounds.width - space * 3) / 2.0
            let one = CGRect(x: (self.bounds.width - cell_width)/2.0, y: space, width: cell_width, height: cell_width)
            let two = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let three = CGRect(x: two.maxX + space, y: two.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three]
        case 4:
            let cell_width = (self.bounds.width - space * 3) / 2.0
            let one = CGRect(x: space, y: space, width: cell_width, height: cell_width)
            let two = CGRect(x: one.maxX + space, y: one.origin.y, width: cell_width, height: cell_width)
            let three = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let four = CGRect(x: three.maxX + space, y: three.origin.y , width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four]
        case 5:
            let cell_width = (self.bounds.width - space * 4) / 3.0
            let one = CGRect(x: (space*3 + cell_width)/2.0, y: space + cell_width/2.0, width: cell_width, height: cell_width)
            let two = CGRect(x: one.maxX + space, y: one.origin.y, width: cell_width, height: cell_width)
            let three = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let four = CGRect(x: three.maxX + space, y: three.origin.y, width: cell_width, height: cell_width)
            let five = CGRect(x: four.maxX + space, y: four.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four,five]
        case 6:
            let cell_width = (self.bounds.width - space * 4) / 3.0
            let one = CGRect(x: space, y: space*2 + cell_width/2.0, width: cell_width, height: cell_width)
            let two = CGRect(x: one.maxX + space, y: one.origin.y, width: cell_width, height: cell_width)
            let three = CGRect(x: two.maxX + space, y: two.origin.y, width: cell_width, height: cell_width)
            let four = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let five = CGRect(x: four.maxX + space, y: four.origin.y, width: cell_width, height: cell_width)
            let six = CGRect(x: five.maxX + space, y: five.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four,five,six]
        case 7:
            let cell_width = (self.bounds.width - space * 4) / 3.0
            let one = CGRect(x: (self.bounds.width - cell_width)/2.0, y: space, width: cell_width, height: cell_width)
            let two = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let three = CGRect(x: two.maxX + space, y: two.origin.y, width: cell_width, height: cell_width)
            let four = CGRect(x: three.maxX + space, y: three.origin.y, width: cell_width, height: cell_width)
            let five = CGRect(x: space, y: four.maxY + space, width: cell_width, height: cell_width)
            let six = CGRect(x: five.maxX + space, y: five.origin.y, width: cell_width, height: cell_width)
            let seven = CGRect(x: six.maxX + space, y: six.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four,five,six,seven]
        case 8:
            let cell_width = (self.bounds.width - space * 4) / 3.0
            let one = CGRect(x: (space*3 + cell_width)/2.0, y: space, width: cell_width, height: cell_width)
            let two = CGRect(x: one.maxX + space, y: one.origin.y, width: cell_width, height: cell_width)
            let three = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let four = CGRect(x: three.maxX + space, y: three.origin.y, width: cell_width, height: cell_width)
            let five = CGRect(x: four.maxX + space, y: four.origin.y, width: cell_width, height: cell_width)
            let six = CGRect(x: space, y: three.maxY + space, width: cell_width, height: cell_width)
            let seven = CGRect(x: six.maxX + space, y: six.origin.y, width: cell_width, height: cell_width)
            let eight = CGRect(x: seven.maxX + space, y: seven.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four,five,six,seven,eight]
        case 9:
            let cell_width = (self.bounds.width - space * 4) / 3.0
            let one = CGRect(x: space, y: space, width: cell_width, height: cell_width)
            let two = CGRect(x: one.maxX + space, y: one.origin.y, width: cell_width, height: cell_width)
            let three = CGRect(x: two.maxX + space, y: two.origin.y, width: cell_width, height: cell_width)
            let four = CGRect(x: space, y: one.maxY + space, width: cell_width, height: cell_width)
            let five = CGRect(x: four.maxX + space, y: four.origin.y, width: cell_width, height: cell_width)
            let six = CGRect(x: five.maxX + space, y: five.origin.y, width: cell_width, height: cell_width)
            let seven = CGRect(x: space, y: four.maxY + space, width: cell_width, height: cell_width)
            let eight = CGRect(x: seven.maxX + space, y: seven.origin.y, width: cell_width, height: cell_width)
            let nine = CGRect(x: eight.maxX + space, y: eight.origin.y, width: cell_width, height: cell_width)
            imageReacts = [one,two,three,four,five,six,seven,eight,nine]
        default:
            break
        }
        
        // 绘制一个填充的矩形
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(Colors.backgroundColor.coloree.cgColor)
        context?.setStrokeColor(Colors.backgroundColor.coloree.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 0, y: self.bounds.width))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.width))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        context?.addLine(to: CGPoint(x: 0, y: 0))
        context?.closePath()
        context?.drawPath(using: .fillStroke)
        
        // 绘制一个一个的小图片
        for (index,image) in images.enumerated() {
            image.draw(in: imageReacts[index])
        }
        
        let groupIconImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = groupIconImage
    }
    
}

