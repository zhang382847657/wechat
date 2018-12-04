//
//  CommentPopoverController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/6.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import CTNetworkingSwift


/// 点赞/评论小弹窗
class CommentPopoverController: UIViewController, UIPopoverPresentationControllerDelegate,CAAnimationDelegate {
    
    
    /// 唯一初始化
    ///
    /// - Parameters:
    ///   - sourceView: 来源视图
    ///   - isLike: 是否已点赞
    ///   - likeClickBack: 点赞回调
    ///   - commentClickBack: 评论点击回调
    required init(sourceView:UIView, dynamicId:Int, isLike:Bool = false, likeClickBack:@escaping ((Bool)->Void), commentClickBack:(()->Void)? = nil) {
        
        super.init(nibName: "CommentPopoverController", bundle: nil)
        
        self.dynamicId = dynamicId
        self.isLike = isLike
        self.likeCallBack = likeClickBack
        self.commentCallBack = commentClickBack
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.delegate = self
        self.popoverPresentationController?.sourceView = sourceView
        self.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: -100, y: 5), size: sourceView.bounds.size)
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.preferredContentSize = CGSize(width: 169, height: 40)
    }
    
    
    /// 点赞按钮
    @IBOutlet weak var likeBtn: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentBtn: UIButton!
    /// 用来做缩放动画的心型图片
    private lazy var heartImageView:UIImageView = {
        let v = UIImageView(image:IconFont(code: IconFontType.心.rawValue, name:kIconFontName, fontSize: 20, color: Colors.themeColor.main3).iconImage)
        return v
    }()
    
    /// 点赞回调
    private var likeCallBack:((Bool)->Void)?
    
    /// 评论点击回调
    private var commentCallBack:(()->Void)?
    
    /// 动态ID
    private var dynamicId:Int!
    
    /// 是否已点赞
    private var isLike:Bool = false
    
    
    private lazy var likeApiManager:WXFriendCircleLikeApiManager = {
        let m = WXFriendCircleLikeApiManager()
        m.delegate = self
        m.paramSource = self
        return m
    }()
    
    private lazy var cancelLikeApiManager:WXFriendCircleCancelLikeApiManager = {
        let m = WXFriendCircleCancelLikeApiManager()
        m.delegate = self
        m.paramSource = self
        return m
    }()
    

   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        likeBtn.setImage(IconFont(code: IconFontType.心.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, for: .normal)
        likeBtn.setImage(IconFont(code: IconFontType.心.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, for: .selected)
        
        commentBtn.setImage(IconFont(code: IconFontType.评论.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, for: .normal)
        commentBtn.setImage(IconFont(code: IconFontType.评论.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, for: .selected)
        
        
        likeBtn.isSelected = isLike
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 点赞/取消点赞
    @IBAction func likeClick(_ sender: UIButton) {
        
        heartImageView.frame = sender.imageView!.frame
        sender.addSubview(heartImageView)

        // 设定为缩放
        let animation = CABasicAnimation(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 0.2 // 动画持续时间
        animation.repeatCount = 1 // 重复次数
        animation.autoreverses = true // 动画结束时执行逆动画
        animation.fromValue = NSNumber(value: 1.0) // 开始时的倍率
        animation.toValue = NSNumber(value: 2.0) // 结束时的倍率
        animation.delegate = self
        // 添加动画
        heartImageView.layer.add(animation, forKey: "scale-layer")
        
        
        if isLike == true { //取消点赞
            cancelLikeApiManager.loadData()
        }else { //点赞
            likeApiManager.loadData()
        }
    
    }
    
    /// 评论
    @IBAction func commentClick(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
        
        if let cb = commentCallBack {
            cb()
        }
    }
    
    
    
    // MARK: UIPopoverPresentationController - Delegate
    
    /// popver弹出效果
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    
    // MARK: CAAnimation - Delegate
    
    /// 动画结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            heartImageView.removeFromSuperview()
            likeBtn.isSelected = !likeBtn.isSelected
            self.dismiss(animated: false, completion: nil)
        }
    }

}


extension CommentPopoverController : CTNetworkingBaseAPIManagerCallbackDelegate {
    func requestDidSuccess(_ apiManager:CTNetworkingBaseAPIManager) {
        
        if apiManager.isKind(of: WXFriendCircleCancelLikeApiManager.self){
            isLike = false
        }else if apiManager.isKind(of: WXFriendCircleLikeApiManager.self){
            isLike = true
        }
        if let cb = likeCallBack {
            cb(isLike)
        }
    }
    func requestDidFailed(_ apiManager:CTNetworkingBaseAPIManager) {
        
    }
}

extension CommentPopoverController : CTNetworkingBaseAPIManagerParamSource {
    func params(for apiManager:CTNetworkingBaseAPIManager) -> ParamsType? {
        return ["dynamicId":dynamicId]
    }
}
