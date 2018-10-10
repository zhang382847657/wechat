//
//  PublishTextViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/17.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 发表纯文字朋友圈
class PublishTextViewController: UIViewController {
    
    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    /// 文本域
    @IBOutlet weak var textView: UITextView!
    
    /// 所在位置图标
    @IBOutlet weak var locationIcon: UIImageView!
    /// 所在位置文案
    @IBOutlet weak var locationLabel: UILabel!
    /// 右侧箭头图标
    @IBOutlet weak var locationArrowIcon: UIImageView!
    
    /// 谁可以看图标
    @IBOutlet weak var whoCanSeeIcon: UIImageView!
    /// 谁可以看文案
    @IBOutlet weak var whoCanSeeLabel: UILabel!
    /// 谁可以看选择状态文案
    @IBOutlet weak var whoCanSeeStateLabel: UILabel!
    /// 谁可以看右侧箭头图标
    @IBOutlet weak var whoCanSeeArrowIcon: UIImageView!
    
    /// 提醒谁看图标
    @IBOutlet weak var remindSeeIcon: UIImageView!
    /// 提醒谁看文案
    @IBOutlet weak var remindSeeLabel: UILabel!
    /// 提醒谁看右侧箭头图标
    @IBOutlet weak var remindSeeArrowIcon: UIImageView!
    
    /// 导航栏
    private lazy var navBar:UINavigationBar = {
        let b = UINavigationBar(frame: CGRect(x: 0, y:  UIApplication.shared.statusBarFrame.height, width: screenBounds.width, height: 44))
        b.barTintColor = UIColor.white
        b.tintColor = Colors.fontColor.font333
        b.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        b.shadowImage = UIImage()
        view.addSubview(b)
        return b
    }()
    
    /// 位置信息
    private var location:[String:Any]?
    
    
    /// 唯一初始化
    required init() {
        super.init(nibName: "PublishTextViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置滚动视图永远有弹性拖拽效果
        scrollView.alwaysBounceVertical =  true
        
        /// 各种图标
        locationIcon.image = IconFont(code: IconFontType.位置.rawValue, fontSize: 20, color: Colors.fontColor.font333).iconImage
        whoCanSeeIcon.image = IconFont(code: IconFontType.我.rawValue, fontSize: 20, color: Colors.fontColor.font333).iconImage
        remindSeeIcon.image = IconFont(code: IconFontType.艾特.rawValue, fontSize: 20, color: Colors.fontColor.font333).iconImage
        
        locationArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, fontSize: 20, color: Colors.fontColor.font999).iconImage
        whoCanSeeArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, fontSize: 20, color: Colors.fontColor.font999).iconImage
        remindSeeArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, fontSize: 20, color: Colors.fontColor.font999).iconImage
       
        
        
        let navigationItem = UINavigationItem(title: "发表文字")
        
        navBar.pushItem(navigationItem, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action: #selector(publish))
        navigationItem.rightBarButtonItem?.tintColor = Colors.themeColor.main
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor:UIColor(hex: "#62b900", alpha: 0.5)], for: .disabled)
        navigationItem.rightBarButtonItem?.isEnabled = false
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 关闭当前视图控制器
    @objc private func close(){
        textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 发表动态
    @objc private func publish(){
        
        WXApi.dynamicAdd(content: textView.text, pictures: nil, longitude: location?["longitude"] as? Double, latitude: location?["latitude"] as? Double, country: location?["country"] as? String, province: location?["province"] as? String, city: location?["city"] as? String, district: location?["district"] as? String, street: location?["street"] as? String, substreet: location?["houseNumber"] as? String, placeName: location?["name"] as? String, video: nil, success: { [weak self](json) in
            
            self?.dismiss(animated: true, completion: nil)
            
        }) { [weak self](error) in
            
         
        }
        
    }
    
    
    /// 选择位置
    @IBAction func chooseLocation(_ sender: UITapGestureRecognizer) {
        
        let nvc = ChooseLocationController.getViewController { [weak self](location) in
            
            self?.location = location
            
            if let location = location {
                self?.locationIcon.image = IconFont(code: IconFontType.位置_选中.rawValue, fontSize: 20, color: Colors.themeColor.main).iconImage
                
                var addressStr = ""
                if let city = location["city"] as? String {
                    addressStr += city
                }
                if let name = location["name"] as? String {
                    addressStr += "·\(name)"
                }
                self?.locationLabel.text = addressStr
                self?.locationLabel.textColor = Colors.themeColor.main
            }else{
                self?.locationIcon.image = IconFont(code: IconFontType.位置.rawValue, fontSize: 20, color: Colors.fontColor.font333).iconImage
                self?.locationLabel.text = "所在位置"
                self?.locationLabel.textColor = Colors.fontColor.font333
            }
        }
        self.present(nvc, animated: true, completion: nil)
    }
    
    /// 选择谁可以看
    @IBAction func whoCanSeeChoose(_ sender: UITapGestureRecognizer) {
        
    }
    
    /// 选择提醒谁看
    @IBAction func chooseRemindSee(_ sender: UITapGestureRecognizer) {
    }

}


extension PublishTextViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
       
        navBar.topItem?.rightBarButtonItem?.isEnabled = textView.text.count > 0
    }
}
