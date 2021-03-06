//
//  MapView+Extension.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    //缩放级别
    var zoomLevel: Int {
        //获取缩放级别
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256)
                / self.region.span.longitudeDelta)) + 1)
        }
        //设置缩放级别
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel,
                                animated: false)
        }
    }
    
    //设置缩放级别时调用
    func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int,
                                     animated: Bool){
        let span = MKCoordinateSpanMake(0,
                                        360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
}
