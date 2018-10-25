//
//  SportOverlayPathRenderer.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/10/22.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics

class SportOverlayPathRenderer: MKOverlayPathRenderer {
    
   
    struct SportSpeed {
        static let slow:(red:CGFloat, green:CGFloat, blue:CGFloat, max:CGFloat) = (0.0, 255.0, 0.0, 2.0)
        static let normal:(red:CGFloat, green:CGFloat, blue:CGFloat, max:CGFloat) = (red:255.0, green:255.0, blue:0.0, max:5.0)
        static let heigh:(red:CGFloat, green:CGFloat, blue:CGFloat, max:CGFloat) = (red:255.0, green:0.0, blue:0.0, max:10.0)
    }
    
    private var sportPolyline:SportPolyline!

    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        self.sportPolyline = overlay as! SportPolyline
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
    
     
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        
        for index in 0 ..< sportPolyline.pointCount {
            
            //当前点的坐标
            let currentPoint = self.point(for: sportPolyline.points()[index])
            //当前点的速度
            let currentSpeed = sportPolyline.cllocations.first!.speed
            //上一个点的速度
            let lastSpeed = sportPolyline.cllocations.last!.speed
            
            //创建一个可变的路径
            let path = CGMutablePath()
            
            if index == 0 { //如果是第一个点，先把路径移动到第一个点
                path.move(to: currentPoint)
                
            }else{
                //上一个点的坐标
                let lastPoint = self.point(for: sportPolyline.points()[index - 1])
            
                //两个点之间进行直线的绘制
                path.move(to: lastPoint)
                path.addLine(to: currentPoint)

                //复制路径，并给线条宽度
                let pathToFill = path.copy(strokingWithWidth: 100, lineCap: self.lineCap, lineJoin: self.lineJoin, miterLimit: self.miterLimit)
                context.addPath(pathToFill)
                context.clip()
                
            
                var starColor:(red:CGFloat, green:CGFloat, blue:CGFloat) = (0.0, 0.0, 0.0)
                var endColor:(red:CGFloat, green:CGFloat, blue:CGFloat) = (0.0, 0.0, 0.0)
                if currentSpeed <= Double(SportSpeed.slow.max){
                    starColor = (SportSpeed.slow.red, SportSpeed.slow.green, SportSpeed.slow.blue)
                }else if currentSpeed <= Double(SportSpeed.normal.max) {
                    starColor = (SportSpeed.normal.red, SportSpeed.normal.green, SportSpeed.normal.blue)
                }else {
                    starColor = (SportSpeed.heigh.red, SportSpeed.heigh.green, SportSpeed.heigh.blue)
                }
                
                if lastSpeed <= Double(SportSpeed.slow.max) {
                    endColor = (SportSpeed.slow.red, SportSpeed.slow.green, SportSpeed.slow.blue)
                }else if lastSpeed <= Double(SportSpeed.normal.max) {
                    endColor = (SportSpeed.normal.red, SportSpeed.normal.green, SportSpeed.normal.blue)
                }else {
                    endColor = (SportSpeed.heigh.red, SportSpeed.heigh.green, SportSpeed.heigh.blue)
                }
                
                //使用rgb颜色空间
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                //颜色数组（这里使用三组颜色作为渐变）fc6820
                let compoents:[CGFloat] = [starColor.red/255, starColor.green/255, starColor.blue/255, 1,
                                           endColor.red/255, endColor.green/255, endColor.blue/255, 1]
                //每组颜色所在位置（范围0~1)
                let locations:[CGFloat] = [0,1.0]
                //生成渐变色（count参数表示渐变个数）
                let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                          locations: locations, count: locations.count)!
                
                //渐变开始位置
                let start = CGPoint(x: lastPoint.x, y: lastPoint.y)
                //渐变结束位置
                let end = CGPoint(x: currentPoint.x, y: currentPoint.y)
                //绘制渐变
                context.drawLinearGradient(gradient, start: start, end: end,
                                           options: .drawsAfterEndLocation)
                
            }

            
        }
        

    }
}
