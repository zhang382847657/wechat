//
//  LocationSearchResultViewController.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/8.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import MapKit

/// 搜索结果视图控制器
class LocationSearchResultViewController: UITableViewController,UISearchResultsUpdating {
    
    /// 搜索结果数据源
    private var dataSource:[[String:Any]] = []
    
    /// 唯一初始化
    ///
    /// - Parameter nav: 导航视图控制器
    required init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false //不加的话，table会下移
        }
        
        self.edgesForExtendedLayout = .init(rawValue: 0) //不加的话，UISearchBar返回后会上移
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
        tableView.keyboardDismissMode = .onDrag
        self.view.backgroundColor = Colors.backgroundColor.main
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 根据关键字进行搜索
    ///
    /// - Parameter text: 搜索关键字
    public func searchLocationWith(keyword text:String?){
        
        dataSource = []
        
        guard let location = User.share.getUserLocation() else {
            return
        }
        
        guard let text = text else {
            tableView.reloadData()
            return
        }
        
        let request: MKLocalSearchRequest = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        let search: MKLocalSearch = MKLocalSearch(request: request)
        search.start { [weak self](response: MKLocalSearchResponse?, error: Error?)  in
            if error == nil {
                let items = response!.mapItems
                for item in items {
                    
                    print(item.name ?? "")
                    self?.dataSource.append(["name":item.name ?? "",
                                             "province":item.placemark.administrativeArea ?? "",
                                             "city":item.placemark.locality ?? "",
                                             "district":item.placemark.subAdministrativeArea ?? "",
                                             "street":item.placemark.thoroughfare ?? "",
                                             "houseNumber":item.placemark.subThoroughfare ?? ""])
                    
                }
                self?.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]["name"] as? String
        cell?.detailTextLabel?.text = "\(dataSource[indexPath.row]["province"] ?? "")\(dataSource[indexPath.row]["city"] ?? "")\(dataSource[indexPath.row]["district"] ?? "")\(dataSource[indexPath.row]["street"] ?? "")"
        return cell!
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChooseLocationController.notificationName_get_chooseLocation), object: nil, userInfo: dataSource[indexPath.row])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchResultsController?.view.isHidden = false
    }
    
    
}
