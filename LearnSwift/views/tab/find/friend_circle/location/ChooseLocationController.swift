//
//  ChooseLocationController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

/// 选择所在位置
class ChooseLocationController: UIViewController {
    
    static let notificationName_get_chooseLocation = "ChooseLocation_get_chooseLocation"
    
    /// TalbeView
    private lazy var tableView:UITableView = {
        let t = UITableView(frame: CGRect.zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.dataSource = self
        t.delegate = self
        view.addSubview(t)
        return t
    }()
    
    /// 搜索视图控制器
    private lazy var searchController:LocationSearchController = {
        let vc = LocationSearchController(tableView: tableView, viewController: self)
        return vc
    }()
    
    /// 定位管理
    private var locationManager = CLLocationManager()
    /// 当前位置
    private var currLocation:CLLocation?
    /// POI数据源
    private var dataSource:[[String:Any]] = []
    /// 选择的位置
    private var chooseLocation:IndexPath?
    /// 选择好位置后的回调
    private var chooseLocationCallBack:(([String:Any]?)->Void)!
    
    
    /// 唯一创建的方法
    ///
    /// - Returns: 返回导航视图控制器
    class func getViewController (chooseLocation:@escaping ((_ location:[String:Any]?)->Void)) -> UINavigationController {
        let vc = ChooseLocationController(nibName: nil, bundle: nil)
        vc.chooseLocationCallBack = chooseLocation
        let nvc = BaseNavigationController(rootViewController: vc)
        return nvc
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "所在位置"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(finish))
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.themeColor.main
        
        tableView.backgroundColor = Colors.backgroundColor.main
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        
        /// 约束
        var contraints = [
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        if #available(iOS 11.0, *) {
            contraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        } else {
            contraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        }
        
        NSLayoutConstraint.activate(contraints)
        
        
        /// 开启定位
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()   //使用应用程序期间允许访问位置数据
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
           // disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            //enableMyWhenInUseFeatures()
            break
        }
        
        // 注册通知 —— 拿到搜索某一地址后的地址信息
        NotificationCenter.default.addObserver(self, selector: #selector(getChooseLocation), name: NSNotification.Name(rawValue: ChooseLocationController.notificationName_get_chooseLocation), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 当点击了某一条地址搜索结果后的通知
    ///
    /// - Parameter noti: 通知
    @objc private func getChooseLocation(noti:Notification){
        
        print("locationDic == \(String(describing: noti.userInfo))")
        chooseLocationCallBack(noti.userInfo as? [String : Any])
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /// 关闭当前视图控制器
    @objc private func close(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /// 完成
    @objc private func finish(){
        
        var finalLocationDic:[String:Any]?
        if let indexPath = chooseLocation {
            if indexPath.row != 0 {
                finalLocationDic = dataSource[indexPath.row - 1]
            }
        }
        // 发送通知把选择的地址传递过去
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChooseLocationController.notificationName_get_chooseLocation), object: nil, userInfo: finalLocationDic)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }

    
    /// POI搜索
    private func poi(latitude:Double, longitude:Double){
        
        let request: MKLocalSearchRequest = MKLocalSearchRequest()
        request.naturalLanguageQuery = "餐饮服务|商务住宅|生活服务"
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        let search: MKLocalSearch = MKLocalSearch(request: request)
        search.start { [weak self](response: MKLocalSearchResponse?, error: Error?)  in
            if error == nil {
                let items = response!.mapItems
                for item in items {

                    print(item.name ?? "")

                    self?.dataSource.append([
                        "name":item.name ?? "",
                        "province":item.placemark.administrativeArea ?? "",
                        "city":item.placemark.locality ?? "",
                        "district":item.placemark.subAdministrativeArea ?? "",
                        "street":item.placemark.thoroughfare ?? "",
                        "houseNumber":item.placemark.subThoroughfare ?? "",
                        "latitude":Double(String(format: "%.7f", item.placemark.coordinate.latitude))!,
                        "longitude":Double(String(format: "%.7f", item.placemark.coordinate.longitude))!
                    ])
                    
                }
                
                self?.tableView.reloadData()
                
            }
            
        }
        
    }
    
   

}

extension ChooseLocationController : UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
        cell?.detailTextLabel?.textColor = Colors.fontColor.font666
        cell?.selectionStyle = .none
        
        if let chooseLocation = chooseLocation {
            cell?.accessoryType = indexPath == chooseLocation ? .checkmark : .none
        }
        
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "不显示位置"
            cell?.textLabel?.textColor = Colors.themeColor.main3
        }else  {
            
            cell?.textLabel?.textColor = Colors.fontColor.font333

            if indexPath.row == 1 {
                cell?.textLabel?.text = dataSource[indexPath.row - 1]["city"] as? String
                cell?.detailTextLabel?.text = nil
            }else{
                cell?.textLabel?.text = dataSource[indexPath.row - 1]["name"] as? String ?? ""
                cell?.detailTextLabel?.text = "\(dataSource[indexPath.row - 1]["province"] ?? "")\(dataSource[indexPath.row - 1]["city"] ?? "")\(dataSource[indexPath.row - 1]["district"] ?? "")\(dataSource[indexPath.row - 1]["street"] ?? "")"
            }
        }
        
        
        return cell!
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        chooseLocation = indexPath
        tableView.reloadData()
    }
}


extension ChooseLocationController : CLLocationManagerDelegate {
    
    /// 获取定位信息
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 取得locations数组的最后一个
        guard let location = locations.last else {
            return
        }
        
        currLocation = location
        
        // 判断是否为空
        if(location.horizontalAccuracy > 0){
            
            // 将经纬度转换为城市名
            lonLatToCity()
            // 停止定位
            locationManager.stopUpdatingLocation()
            
        }
        
        
    }
    
    /// 定位出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    

    /// 将经纬度转换为城市名
    private func lonLatToCity() {
        
        guard let currLocation = currLocation else {
            return
        }
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { [weak self](placemark, error) -> Void in
            
            if(error == nil){
                
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                
                // 经度
                let latitude = Double(String(format: "%.7f", mark.location!.coordinate.latitude))!
                // 纬度
                let longitude = Double(String(format: "%.7f",  mark.location!.coordinate.longitude))!
                // 国家
                let country = mark.country ?? ""
                // 国家编号
                let countryCode = mark.isoCountryCode ?? ""
                // 省
                let province =  mark.administrativeArea ?? ""
                // 城市 | 直辖市
                let city = mark.locality ?? mark.administrativeArea ?? ""
                // 区
                let district = mark.subLocality ?? ""
                // 其他行政区域信息（自治区等）
                let subAdministrativeArea = mark.subAdministrativeArea ?? ""
                // 街道
                let street = mark.thoroughfare ?? ""
                // 子街道
                let houseNumber = mark.subThoroughfare ?? ""
                // 位置名
                let name = mark.name ?? ""
                // 邮编
                let postalCode = mark.postalCode ?? ""
                // 水源，湖泊
                let inlandWater = mark.inlandWater ?? ""
                //  海洋
                let ocean = mark.ocean ?? ""
                
                print("经度:\(latitude)")
                print("纬度:\(longitude)")
                print("国家 == \(country)")
                print("国家编码 == \(countryCode)")
                print("省 == \(province)")
                print("市 == \(city)")
                print("区 == \(district)")
                print("其他行政区域信息（自治区等） == \(subAdministrativeArea)")
                print("街道 == \(street)")
                print("门牌号 == \(houseNumber)")
                print("地名 == \(name)")
                print("邮编 == \(postalCode)")
                print("水源，湖泊 == \(inlandWater)")
                print("海洋 == \(ocean)")
               
                
                // 保存用户当前经纬度
                User.share.saveUserLocation(lat: latitude, long: longitude)

                
                self?.dataSource.append(["province":province,
                                         "city":city,
                                         "district":district,
                                         "street":street,
                                         "houseNumber":houseNumber,
                                         "latitude":latitude,
                                         "longitude":longitude])
                self?.poi(latitude: latitude, longitude: longitude)
                
                
            }else{
                print("位置信息转城市失败 == \(error!)")
            }
        }
        
    }

}
