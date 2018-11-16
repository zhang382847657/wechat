//
//  NetworkReachability.swift
//  Alamofire
//
//  Created by 张琳 on 2018/11/8.
//

import Alamofire

/// 网络状态改变的协议
public protocol ZLNerworkReachabilityDelegate: AnyObject {
    func networkStateChange(state:ZLNetworkReachableState)
}


/// 当前网络状态类型
///
/// - unknown: 未识别的网络
/// - notReachable: 不可用的连接（未连接）
/// - wwan: 2G 3G 4G
/// - wifi: WiFi
public enum ZLNetworkReachableState {
    case unknown
    case notReachable
    case wwan
    case wifi
}


/// 网络状态监测类
public class ZLNetworkReachabilityManager: NSObject {
    
    
    /// 单例
    public static let share = ZLNetworkReachabilityManager()
    /// 代理
    public weak var delegate:ZLNerworkReachabilityDelegate? = nil
   

    override init() {
        
        super.init()
        
        manager.listener = { [weak self]status in
            
            guard let weakSelf = self else {
                return
            }
        
            switch status {
            case .unknown:
                weakSelf.delegate?.networkStateChange(state: ZLNetworkReachableState.unknown)
                break
            case .notReachable:
                weakSelf.delegate?.networkStateChange(state: ZLNetworkReachableState.notReachable)
            case .reachable:
                if weakSelf.manager.isReachableOnWWAN {
                    weakSelf.delegate?.networkStateChange(state: ZLNetworkReachableState.wwan)
                } else if weakSelf.manager.isReachableOnEthernetOrWiFi {
                    weakSelf.delegate?.networkStateChange(state: ZLNetworkReachableState.wifi)
                }
                break
            }
        }
        
    }
    
    /// 开启网络监听
    ///
    /// - Parameter status: 网络状态回调
    public func startListening() {
        manager.startListening()
    }


    /// 停止网络监听
    public func stopListening() {
        manager.stopListening()
    }
    
    
    /// Alamofire网络监测管理对象
    private lazy var manager:NetworkReachabilityManager = {
        let m = NetworkReachabilityManager(host: "www.apple.com")
        return m!
    }()
    
}
