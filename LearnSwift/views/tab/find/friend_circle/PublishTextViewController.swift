//
//  PublishTextViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/17.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

/// 发表纯文字朋友圈
class PublishTextViewController: UIViewController {
    
    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    /// 文本域
    @IBOutlet weak var textView: UITextView!
    /// 文本域高度
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    /// 选择图片/视频组件
    @IBOutlet weak var choosePictureView: ChoosePictureView!
    
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
    
    /// 位置信息
    private var location:[String:Any]?
    
    
    
    /// 获得带导航视图控制器的发布动态界面
    ///
    /// - Returns: 带导航栏的视图控制器
    public class func getViewController() -> UINavigationController{
        let vc = PublishTextViewController()
        let nvc = BaseNavigationController(rootViewController: vc)
        return nvc
    }
    
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
        locationIcon.image = IconFont(code: IconFontType.位置.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font333).iconImage
        whoCanSeeIcon.image = IconFont(code: IconFontType.我.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font333).iconImage
        remindSeeIcon.image = IconFont(code: IconFontType.艾特.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font333).iconImage
        
        locationArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font999).iconImage
        whoCanSeeArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font999).iconImage
        remindSeeArrowIcon.image = IconFont(code: IconFontType.右箭头.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font999).iconImage
       
        
        
        self.navigationItem.title = "发表文字"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = Colors.fontColor.font333
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.fontColor.font333
        
     
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action: #selector(publish))
        
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.themeColor.main
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor:UIColor(hex: "#62b900", alpha: 0.5)], for: .disabled)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    
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
    
        // 上传后图片地址数组
        var pictureArray:[String] = []
        // 上传后视频地址
        var video:String?
        
        if choosePictureView.selectedPhotos.count > 0 {
            
            // 创建线程组
            let group = DispatchGroup()
            
            for (index,value) in choosePictureView.selectedAssets.enumerated() {
                
                // 把该任务添加到组队列中执行
                group.enter()
            
                let fileName:String = value.value(forKey: "filename") as! String
                let fileSize:Int64? = PHAssetResource.assetResources(for: value).first?.value(forKey: "fileSize") as? Int64
                // TODO: 这里要判断文件大小，如果超过200M要提示用户文件太大了
                if let fileSize = fileSize {
                    print("文件大小 == \(fileSize)")
                }
                
                // 异步执行
                DispatchQueue.main.async(group: group, qos: .default, flags: []) {[weak self] in
                    
                    guard let weakSelf = self else {
                        return
                    }
                    
                    weakSelf.getDataWith(asset: value, image: weakSelf.choosePictureView.selectedPhotos[index], success: { (fileData)  in
                        
                        let fileType = value.mediaType == .video ? NetWork.FileUploadType.video : NetWork.FileUploadType.image
                        
                        // 上传图片/视频
                        NetWork.uploadFile(fileData: fileData, fileName: fileName, fileType: fileType, success: { (url) in
                            
                            if fileType == NetWork.FileUploadType.image {
                                pictureArray.append(url)
                            }else if fileType == NetWork.FileUploadType.video {
                                video = url
                            }
                            
                            //执行完之后从组队列中移除
                            group.leave()
                    
                            
                        }) { (error) in
                            //执行完之后从组队列中移除
                            group.leave()
                        
                        }
                        
                    }) { (error) in
                        //执行完之后从组队列中移除
                        group.leave()
                    }
                }
                
             
            
            }
            
            // 当上面所有的任务执行完之后通知
            group.notify(queue: DispatchQueue.main) { [weak self] in
    
                var pictures:String? = pictureArray.joined(separator: ",")
                if pictures == "" {
                    pictures = nil
                }
                
                self?.publishDynamic(pictures: pictures, video: video)
            }
           
           
        }else{
            publishDynamic(pictures: nil, video: nil)
        }
        
      
    }
    
    /// 得到相册资源对应的data流跟文件名
    ///
    /// - Parameters:
    ///   - asset: 相册资源对象
    ///   - image: 图片对象
    ///   - success: 成功的回调  返回文件data以及文件名
    ///   - failed: 失败的回调
    private func getDataWith(asset:PHAsset,image:UIImage, success:@escaping ((_ fileData:Data)->Void), failed:@escaping ((Error)->Void)){
        
        if asset.mediaType == .video {
            
            let options = PHVideoRequestOptions()
            options.version = PHVideoRequestOptionsVersion.current
            options.deliveryMode = .automatic
            let manager = PHImageManager.default()
            manager.requestAVAsset(forVideo: asset, options: options) { (asset, audioMix, info) in
                
                
                if let asset:AVURLAsset = asset as? AVURLAsset {
                    do{
                        print("视频地址 == \(asset.url.absoluteString)")
                        success(try Data(contentsOf: asset.url))
                    }catch{
                        failed(NetWork.NetWorkError.InvalidValue)
                    }
                }else{
                    failed(NetWork.NetWorkError.InvalidValue)
                }
            }
            
            
        }else{
            if let data = UIImagePNGRepresentation(image) {
                success(data)
            }else{
                failed(NetWork.NetWorkError.InvalidValue)
            }
        }
    }
    
    
    /// 发布动态
    ///
    /// - Parameters:
    ///   - pictures: 图片地址数组字符串
    ///   - video: 视频地址
    private func publishDynamic(pictures:String?, video:String?){
        
        WXApi.dynamicAdd(content: textView.text, pictures: pictures, longitude: location?["longitude"] as? Double, latitude: location?["latitude"] as? Double, country: location?["country"] as? String, province: location?["province"] as? String, city: location?["city"] as? String, district: location?["district"] as? String, street: location?["street"] as? String, substreet: location?["houseNumber"] as? String, placeName: location?["name"] as? String, video: video, success: { [weak self](json) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeixinViewController.notificationName_refresh), object: nil, userInfo: nil)
            self?.dismiss(animated: true, completion: nil)
            
        }) { [weak self](error) in
            
            
        }
    }
    
    
    /// 选择位置
    @IBAction func chooseLocation(_ sender: UITapGestureRecognizer) {
        
        let nvc = ChooseLocationController.getViewController { [weak self](location) in
            
            self?.location = location
            
            if let location = location {
                self?.locationIcon.image = IconFont(code: IconFontType.位置_选中.rawValue, name:kIconFontName, fontSize: 20, color: Colors.themeColor.main).iconImage
                
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
                self?.locationIcon.image = IconFont(code: IconFontType.位置.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font333).iconImage
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
        self.navigationItem.rightBarButtonItem?.isEnabled = textView.text.count > 0
    }
    
    /// 计算输入框文字真实的高度
    private func heightForTextView(textView:UITextView, withText strText:NSString) -> CGFloat {
        
        let constraint = CGSize(width: textView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = strText.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: 16.0)], context: nil)
        let textHeight = size.size.height + (textView.font!.lineHeight)
        return textHeight < 85 ? 85 : textHeight
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 输入框高度
        var height:CGFloat = 0.0
        
        if text == "" { //如果是删除文字操作
            
            if textView.text != "" {
                height = heightForTextView(textView: textView, withText: textView.text.prefix(textView.text.count - 1) as NSString)
            }else{
                height = heightForTextView(textView: textView, withText: textView.text! as NSString)
            }
            
        }else{ //如果是输入文字
            height = heightForTextView(textView: textView, withText: "\(textView.text!)\(text)" as NSString)
        }
        
        // 当输入框大于200，就不再继续增加高度了
        if height >= 200 {
            return true
        }
        
        textViewHeight.constant = height
        
        // 给约束加一个动画效果
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            
            self?.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        return true
        
        
    }
}
