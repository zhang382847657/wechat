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

class WeixinCell: UITableViewCell {
    
    /// Cell标识
    static let identifier_weixin = "WeixinCell"
    /// 视图模型
    public var viewModel:WeixinCellModel! {
        didSet {
            bindViewModel()
        }
    }
    /// 全文/收起按钮点击回调
    public var btnCallBack:((Bool)->Void)?
    /// 评论点击回调
    public var commentClickBack:((_ senderView:UIButton)->Void)?
    
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: WeixinCell
    public class func getCell(tableView:UITableView, viewModel:WeixinCellModel) -> WeixinCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier_weixin) as? WeixinCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier_weixin) as? WeixinCell
        }
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
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置头像圆角
        headImageView.setCornerRadio(radio: headImageView.bounds.height / 2.0, borderColor: UIColor(hex: "#eeeeee"), borderWidth: 1)
    
        name.text = ""
        subTitle.text = ""
        timeLable.text = ""
        locationLabel.text = nil
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: screenBounds.width)
        ])
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
        
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 评论点击
    @IBAction func commentClick(_ sender: UIButton) {
        
        if let cb = commentClickBack {
            cb(sender)
        }
    }
    
    /// 全文/收起点击
    @IBAction func btnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        subTitle.numberOfLines = sender.isSelected ? 0 : maxLineNumber

        if let cb = btnCallBack {
            cb(sender.isSelected)
        }
    }
}
