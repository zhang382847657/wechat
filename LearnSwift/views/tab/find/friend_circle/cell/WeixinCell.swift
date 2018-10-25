//
//  WeixinCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/23.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXCategory

//extension Array {
//
//
//    func my_filter(_filter:((Element)->Bool)) -> Array{
//
//        var finalArray:[Element] = []
//
//        for value in self {
//
//            if _filter(value) == true {
//                finalArray.append(value)
//            }
//
//        }
//
//        return finalArray
//
//    }
//
//}

class WeixinCell: UITableViewCell {
    
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
    /// 全文/收起按钮点击回调
    var btnCallBack:((Bool)->Void)?
    /// 评论点击回调
    var commentClickBack:((_ senderView:UIButton)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置头像圆角
        headImageView.setCornerRadio(borderColor: UIColor(hex: "#eeeeee"), borderWidth: 1)
    
        name.text = ""
        subTitle.text = ""
        timeLable.text = ""
        locationLabel.text = nil
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: screenBounds.width)
        ])
    }
    
    
    
    /// 更新UI
    ///
    /// - Parameter data: 数据源
    func setupUI(data:Dictionary<String,Any>){
        
        let user:[String:Any] = data["user"] as? [String : Any] ?? [:]
        
        let headerImageUrl = user["headPicture"] as? String
        let nameStr = user["name"] as? String
        let subTitleStr:String? = data["content"] as? String
        let time = data["createtime"] as? String
        let placeName = data["placeName"] as? String
        let city = data["city"] as? String
        let isSelect:Bool = data["isSelect"] as? Bool ?? false
        let pictures = data["pictures"] as? String
        let dyanmicImageUrl = pictures?.components(separatedBy: ",") ?? []
        
        let likesData:[[String:Any]]? = data["likes"] as? [[String : Any]]
        let commentData:[[String:Any]]? = data["comment"] as? [[String : Any]]
        
        var finalLocationStr:String?
        if let city = city {
            finalLocationStr = city
            if let placeName = placeName {
                finalLocationStr! += "·\(placeName)"
            }
        }
        

        name.text = nameStr
        timeLable.text = time?.stringConvertDate()?.dateConvertFriendCircleType()
        subTitle.text = subTitleStr
        headImageView.setNetWrokUrl(imageUrl: headerImageUrl)
        locationLabel.text = finalLocationStr
       
       
        // 计算内容的真实高度，算出来行高后，如果超过了指定行数，就显示全文/收起的按钮
        subTitle.numberOfLines = 0
        let labelHeight = subTitle.sizeThatFits(CGSize(width: subTitle.bounds.width, height: CGFloat(MAXFLOAT))).height
        let lineCount:Int = Int(labelHeight / subTitle.font.lineHeight)
        
        btn.isHidden = lineCount > maxLineNumber ? false : true
        btn.isSelected = isSelect
        btnHeight.constant = lineCount > maxLineNumber ? 25 : 0
        btnTop.constant = btn.isHidden ? 0 : 6
        
        subTitle.numberOfLines = isSelect ? 0 : maxLineNumber
        

        // 设置九宫格图片
        dynamicImageView.updateUIWith(imageArray: dyanmicImageUrl)
        
        
        // 设置评论模块
        commentTop.constant = (likesData != nil && likesData!.count > 0) ? 6 : 0
        commentView.likeData = likesData
        commentView.commentData = commentData
        
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
