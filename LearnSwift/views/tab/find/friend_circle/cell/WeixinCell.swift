//
//  WeixinCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/23.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXCategory
import WXTools
import CTNetworkingSwift



/// 朋友圈冬天协议
protocol WeixinCellDelegate:NSObjectProtocol {
    
    /// 全文展开/收起点击
    func contentShowAll(showAll:Bool, viewModel:WeixinCellModel, indexPath:IndexPath)
    /// 展示点赞/评论模块
    func showCommentPopoverController(popView:CommentPopoverController)
    /// 点赞
    func chooseLike(viewModel:WeixinCellModel, indexPath:IndexPath)
    /// 发送评论
    func sendComment(viewModel:WeixinCellModel, indexPath:IndexPath)
    /// 回复评论
    func replyComment(viewModel:WeixinCellModel, indexPath:IndexPath)
    /// 删除评论
    func deleteComment(viewModel:WeixinCellModel, indexPath:IndexPath)
    
}

/// 朋友圈动态Cell
class WeixinCell: UITableViewCell{
    
    /// Cell标识
    static let identifier = "WeixinCell"
    /// Cell代理
    public weak var delegate:WeixinCellDelegate? = nil
    /// Cell所在索引
    var indexPath:IndexPath!
    /// Cell所在TabelView
    var tableView:UITableView!
    /// 视图模型
    var viewModel:WeixinCellModel! {
        didSet {
            bindViewModel()
        }
    }
   
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: WeixinCell
    public class func getCell(tableView:UITableView, indexPath:IndexPath, viewModel:WeixinCellModel) -> WeixinCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? WeixinCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier) as? WeixinCell
        }
        cell!.tableView = tableView
        cell!.indexPath = indexPath
        cell!.viewModel = viewModel
        return cell!
    }
    
    /// 姓名
    @IBOutlet weak var name: UILabel!
    /// 副标题
    @IBOutlet weak var subTitle: UILabel!
    /// 头像
    @IBOutlet weak var headImageView: UIImageView!
    /// 全文/收起按钮上边约束
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    /// 全文/收起按钮
    @IBOutlet weak var btn: UIButton!
    /// 全文/收起按钮高度约束
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    /// 动态图片
    @IBOutlet weak var dynamicImageView:GridImageView!
    /// 动态图片上边的约束
    @IBOutlet weak var dynamicImageViewTop: NSLayoutConstraint!
    /// 时间
    @IBOutlet weak var timeLable: UILabel!
    /// 定位
    @IBOutlet weak var locationLabel: UILabel!
    /// 评论模块上边约束
    @IBOutlet weak var commentTop: NSLayoutConstraint!
    /// 评论视图
    @IBOutlet weak var commentView: CommentView!
    /// 副标题允许展示的最大行数
    private let maxLineNumber:Int = 4
    
    /// 朋友圈添加评论ApiManager
    private lazy var wxFriendCircleAddCommentApiManager:WXFriendCircleAddCommentApiManager = {
        let m = WXFriendCircleAddCommentApiManager()
        m.delegate = self
        m.paramSource = self
        return m
    }()
    
    /// 朋友圈回复评论ApiManager
    private lazy var wxFriendCircleReplyCommentApiManager:WXFriendCircleReplyCommentApiManager = {
        let m = WXFriendCircleReplyCommentApiManager()
        m.delegate = self
        m.paramSource = self
        return m
    }()
    
    /// 朋友圈删除评论ApiManager
    private lazy var wxFriendCircleDeleteCommentApiManager:WXFriendCircleDeleteCommentApiManager = {
        let m = WXFriendCircleDeleteCommentApiManager()
        m.delegate = self
        m.paramSource = self
        return m
    }()
    
    /// 评论内容
    private var replayContent:String?
    /// 要删除/回复的评论ID
    private var commentId:Int?
    /// 被回复人的ID
    private var replayUserId:Int?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headImageView.setCornerRadio(radio: headImageView.bounds.height / 2.0, borderColor: UIColor(hex: "#eeeeee"), borderWidth: 1)
        name.text = ""
        subTitle.text = ""
        timeLable.text = ""
        locationLabel.text = nil
        
        // 回复评论点击回调
        commentView.commentClickBlock = {[weak self] (data) in
            
            guard let weakSelf = self, let id = User.share.id, let userId = data["userId"] as? Int, let commentId = data["id"] as? Int else {
                return
            }
            
            self?.commentId = commentId
            self?.replayUserId = userId
            
            
            if userId == id { //说明点击的是自己的评论，则就删除评论
                
                Alert.show(viewcontroller: UIViewController.getCurrentViewController(), title: "提示", message: "是否要删除此评论", done: { [weak self] in
                    print("sdfsdfsdfsdf")
                    self?.wxFriendCircleDeleteCommentApiManager.loadData()
                })
                
            } else { //否则就是回复别人的评论
                
                
                ReplayTools.share.showReplayView(text: nil, placheolder: "回复\(data["name"] as? String ?? "--")", tableView: weakSelf.tableView, cell: weakSelf, sendClick: { [weak self](text) in
                    
                    self?.replayContent = text
                    self?.wxFriendCircleReplyCommentApiManager.loadData()
                    
                })
                
            }
            
        }

    }
    
    /// 绑定VM，展示数据
    private func bindViewModel() {
    
        name.text = viewModel.name
        timeLable.text = viewModel.time
        subTitle.text = viewModel.content
        locationLabel.text = viewModel.location
        
      
        headImageView.setImage(withUrl: viewModel.headerImageUrl, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
       
       
        // 计算内容的真实高度，算出来行高后，如果超过了指定行数，就显示全文/收起的按钮
        subTitle.numberOfLines = 0
        let labelHeight = subTitle.sizeThatFits(CGSize(width: subTitle.bounds.width, height: CGFloat(MAXFLOAT))).height
        let lineCount:Int = Int(labelHeight / subTitle.font.lineHeight)
        
        btn.isHidden = lineCount > maxLineNumber ? false : true
        btn.isSelected = viewModel.showAll
        btnHeight.constant = lineCount > maxLineNumber ? 25 : 0
        btnTop.constant = btn.isHidden ? 0 : 6
        
        subTitle.numberOfLines = viewModel.showAll ? 0 : maxLineNumber
        

        // 设置九宫格图片
        dynamicImageView.updateUIWith(imageArray: viewModel.dynamicImageUrls)
        
        
        // 设置评论模块
        commentTop.constant = (viewModel.likesData != nil && viewModel.likesData!.count > 0) ? 6 : 0
        commentView.likeData = viewModel.likesData
        commentView.commentData = viewModel.commentData

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 评论点击
    @IBAction func commentClick(_ sender: UIButton) {
        
        let pop =  CommentPopoverController(sourceView: sender, dynamicId: viewModel.id, isLike: viewModel.isLike, likeClickBack: { [weak self](isLike) in
            
            guard let weakSelf = self else {
                return
            }
            
            var finalViewModel:WeixinCellModel = weakSelf.viewModel
            finalViewModel.isLike = isLike
            
            if var likesData = weakSelf.viewModel.likesData, let wxId = User.share.wxId {
                
                if isLike {
                    
                    likesData.append(["name":User.share.name ?? NSNull(),"wxId":wxId])
                    
                } else {
                    for (index,value) in likesData.enumerated() {
                        if value["wxId"] as! String == wxId {
                            likesData.remove(at: index)
                            break
                        }
                    }
                }
                
                finalViewModel.likesData = likesData
            }
            
            weakSelf.delegate?.chooseLike(viewModel: finalViewModel, indexPath: weakSelf.indexPath)
            
            }, commentClickBack: { [weak self] in //评论点击回调
                
                guard let weakSelf = self else {
                    return
                }
                
                // 显示评论的输入框
                ReplayTools.share.showReplayView(text: nil, tableView: weakSelf.tableView, cell: weakSelf, sendClick: { [weak self] (text) in
                    
                    self?.replayContent = text
                    self?.wxFriendCircleAddCommentApiManager.loadData()
                    
                })
                
        })
        
        delegate?.showCommentPopoverController(popView: pop)
    }
    
    /// 全文/收起点击
    @IBAction func btnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        subTitle.numberOfLines = sender.isSelected ? 0 : maxLineNumber
        delegate?.contentShowAll(showAll: sender.isSelected, viewModel: viewModel, indexPath: indexPath)
       
    }
}


//MARK: API参数设置
extension WeixinCell : CTNetworkingBaseAPIManagerParamSource {
    func params(for apiManager:CTNetworkingBaseAPIManager) -> ParamsType? {
        
        if apiManager.isKind(of: WXFriendCircleAddCommentApiManager.self)  { //添加评论
            return ["dynamicId":viewModel.id,"content":replayContent ?? NSNull()]
        }
        if apiManager.isKind(of: WXFriendCircleDeleteCommentApiManager.self){ //删除评论
            return ["commentId":commentId ?? NSNull()]
        }
        if apiManager.isKind(of: WXFriendCircleReplyCommentApiManager.self){ //回复评论
            return ["dynamicId":viewModel.id,"content":replayContent ?? NSNull(),"replyUserId":replayUserId ?? NSNull()]
        }
        return nil
    }
}

//MARK: API请求成功/失败回调
extension WeixinCell : CTNetworkingBaseAPIManagerCallbackDelegate {
    
    func requestDidSuccess(_ apiManager:CTNetworkingBaseAPIManager) {
        
        if apiManager.isKind(of: WXFriendCircleAddCommentApiManager.self) { //添加评论
            
            let json = apiManager.fetchAsJSON()
            var finalViewModel:WeixinCellModel = viewModel
            
            if var commentData = viewModel.commentData, let jsonDic = json?.dictionaryObject {
                commentData.append(jsonDic)
                finalViewModel.commentData = commentData
                delegate?.sendComment(viewModel: finalViewModel, indexPath: indexPath)
            }
            
        } else if apiManager.isKind(of: WXFriendCircleReplyCommentApiManager.self) { //回复评论
            
            let json = apiManager.fetchAsJSON()
            var finalViewModel:WeixinCellModel = viewModel
            
            if var commentData = viewModel.commentData, let jsonDic = json?.dictionaryObject {
                commentData.append(jsonDic)
                finalViewModel.commentData = commentData
                delegate?.replyComment(viewModel: finalViewModel, indexPath: indexPath)
            }
            
        } else if apiManager.isKind(of: WXFriendCircleDeleteCommentApiManager.self) { //删除评论
        
            var finalViewModel:WeixinCellModel = viewModel
            
            if var commentData = viewModel.commentData {
                for (index,value) in commentData.enumerated() {
                    if value["id"] as? Int == commentId {
                        commentData.remove(at: index)
                        break
                    }
                }
                finalViewModel.commentData = commentData
                delegate?.deleteComment(viewModel: finalViewModel, indexPath: indexPath)
            }
            
        }
        
        
    }
    func requestDidFailed(_ apiManager:CTNetworkingBaseAPIManager) {
        if apiManager .isKind(of: WXFriendCircleAddCommentApiManager.self) {
            
        }
    }
}

