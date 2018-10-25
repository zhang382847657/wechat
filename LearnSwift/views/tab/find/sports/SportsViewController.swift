//
//  SportsViewController.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import MapKit

class SportsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    /// 地图
    @IBOutlet weak var mapView: MKMapView!
    /// 开始运动/结束运动按钮
    @IBOutlet weak var recordBtn: UIButton!
    
    private lazy var locatiomManager:CLLocationManager = {
        let m = CLLocationManager()

        //设置定位的精度
        m.desiredAccuracy = kCLLocationAccuracyBest
        //位置信息更新最小距离
        m.distanceFilter = 10
        //设置代理
        m.delegate = self
        
        //如果没有授权则请求用户授权,
        //因为 requestAlwaysAuthorization 是 iOS8 后提出的,需要添加一个是否能响应的条件判断,防止崩溃
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined && m.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))  {
            m.requestAlwaysAuthorization()
        }
    
        return m
    }()
    
    /// 记录所有定位的数组
    private var locationMutableArray:[CLLocation] = []
    
    
  
    /// 唯一初始化
    required init() {
        super.init(nibName: "SportsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "运动轨迹"
        
      
       
        
        //用户位置追踪
        mapView.userTrackingMode = .follow
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 开始或者结束运动
    @IBAction func startOrStopSport(_ sender: UIButton) {
        
        
        if sender.isSelected  {
            self.locatiomManager.stopUpdatingLocation()
            
        }else{
            //是否启用定位服务
            if CLLocationManager.locationServicesEnabled() {
                print("开始定位")
                //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
                self.locatiomManager.startUpdatingLocation()
            }else{
                print("定位服务为关闭状态,无法使用定位服务")
            }
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    /// 两点之间距离的计算
    ///
    /// - Parameters:
    ///   - start: 开始的坐标
    ///   - end: 结束的坐标
    /// - Returns: 返回距离 单位米
    private func calculateDistanceWith(start:CLLocationCoordinate2D, end:CLLocationCoordinate2D) -> Double {
        
        //根据角度计算弧度
        func radian(d:Double) -> Double {
            return d * Double.pi/180.0
        }
        
        let EARTH_RADIUS:Double = 6378137.0
        
        let radLat1:Double = radian(d: start.latitude)
        let radLat2:Double = radian(d: end.latitude)
        
        let radLng1:Double = radian(d: start.longitude)
        let radLng2:Double = radian(d: end.longitude)
        
        let a:Double = radLat1 - radLat2
        let b:Double = radLng1 - radLng2
        
        var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b/2), 2)))
        s = s * EARTH_RADIUS
        return s
        
    }
    

    //MARK MKMapViewDelegate
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        
        if overlay is SportPolyline {
            let polylineRenderer = SportOverlayPathRenderer(overlay: overlay) //MKPolylineRenderer(overlay: overlay)
            
//            let currentSpeed = (overlay as! SportPolyline).cllocations.last!.speed
//            let lastSpeed = (overlay as! SportPolyline).cllocations.first!.speed

            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return nil
       
    }
    
    
    //MARK CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("用户还未进行授权")
        case .authorizedAlways:
            print("授权允许在前台和后台均可使用定位服务")
        case .authorizedWhenInUse:
            print("授权允许在前台可使用定位服务")
        case .denied:
            // 判断当前设备是否支持定位和定位服务是否开启
          
            if CLLocationManager.locationServicesEnabled() {
                print("用户不允许程序访问位置信息或者手动关闭了位置信息的访问，帮助跳转到设置界面")
                let url = URL(string: UIApplicationOpenSettingsURLString)!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }else{
                print("定位服务关闭,弹出系统的提示框,点击设置可以跳转到定位服务界面进行定位服务的开启")
            }
        case .restricted:
            print("受限制的")
        }
    }
    
    /**
     我们并没有把从 CLLocationManager 取出来的经纬度放到 mapView 上显示
     原因:
     我们在此方法中取到的经纬度依据的标准是地球坐标,但是国内的地图显示按照的标准是火星坐标
     MKMapView 不用在做任何的处理,是因为 MKMapView 是已经经过处理的
     也就导致此方法中获取的坐标在 mapView 上显示是有偏差的
     解决的办法有很多种,可以上网就行查询,这里就不再多做赘述
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 设备的当前位置
        
        guard let currLocation = locations.last else {
            return
        }
        
        let latitude = String(format: "%3.5f", arguments: [currLocation.coordinate.latitude])
        let longitude = String(format: "%3.5f", arguments: [currLocation.coordinate.longitude])
        let speed = currLocation.speed
        
        print("当前用户位置:纬度\(latitude),经度:\(longitude),速度:\(speed)")
        
        //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        //        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //        let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: span)
        // mapView.setRegion(region, animated: true)
        
        if locationMutableArray.count > 0 {
            
            //上一次记录的点
            let startCoordinate = locationMutableArray.last!
            
            //当前确定到的位置数据
            let endCoordinate = currLocation
            
            //移动距离的计算
            let meters = startCoordinate.distance(from: endCoordinate)
            print("距离为 == \(meters)")
            
            //为了美化移动的轨迹,移动的位置超过10米,方可添加进位置的数组
            if meters >= 10 {
                print("添加进数组")
                
                //将当前的位置添加到位置数组
                locationMutableArray.append(currLocation)
                
             
                //开始绘制轨迹
                let polyline = SportPolyline(coordinates: [startCoordinate.coordinate,endCoordinate.coordinate], count: 2)
                polyline.cllocations = [startCoordinate, endCoordinate]
                mapView.addOverlays([polyline])
                
                // 将最新的点定位到界面正中间显示
                self.mapView.setCenter(locationMutableArray.last!.coordinate, animated: true)
                
            }else{
                print("不添加进数组")
            }
            
        }else{
            //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
            locationMutableArray.append(currLocation)
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("无法获取当前位置 error : \(error)")
    }

}
