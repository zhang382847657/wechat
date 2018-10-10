//
//  CommentView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/7.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class CommentView: UIView {
    
    /// 点赞数据
    var likeData:[[String:Any]]?{
        didSet{
            setUI()
        }
    }
    
    /// 评论数据
    var commentData:[[String:Any]]?{
        didSet{
            setUI()
        }
    }
    
    /// 评论点击回调
    var commentClickBlock:((_ data:Dictionary<String,Any>)->Void)?
    
    
    /// 点赞视图
    private lazy var likeView:UILabel = {
        let l = UILabel()
        l.font = UIFont(name: IconFont.iconfontName, size: 14.0)
        l.numberOfLines = 0
        l.textColor = Colors.themeColor.main3
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    /// 评论视图
    private var commentView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    /// 组件基础设置
    private func config(){
        // 背景色设为透明
        self.backgroundColor = UIColor.white
    }
    

    override func draw(_ rect: CGRect) {

        //获取绘图上下文
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 创建一个新的空图形路径。
        ctx.beginPath()
        
        //起始点
        let origin_x = rect.origin.x + 8 + 5
        let origin_y = rect.origin.y
        
        //第一条线的位置坐标
        let line_1_x = rect.origin.x + 8
        let line_1_y = rect.origin.y + 5
        
        //第二条线的位置坐标
        let line_2_x = rect.origin.x
        let line_2_y = rect.origin.y + 5
        
        //第三条线的位置坐标
        let line_3_x = line_2_x
        let line_3_y = rect.origin.y + rect.height
        
        //第四条线位置坐标
        let line_4_x = rect.origin.x + rect.width
        let line_4_y = line_3_y
        
        //第五条线位置坐标
        let line_5_x = line_4_x
        let line_5_y = rect.origin.y + 5
        
        //第六条线位置坐标
        let line_6_x = origin_x + 5
        let line_6_y = rect.origin.y + 5
        
        // 开始绘制线条
        ctx.move(to: CGPoint(x: origin_x, y: origin_y))
        ctx.addLine(to: CGPoint(x: line_1_x, y: line_1_y))
        ctx.addLine(to: CGPoint(x: line_2_x, y: line_2_y))
        ctx.addLine(to: CGPoint(x: line_3_x, y: line_3_y))
        ctx.addLine(to: CGPoint(x: line_4_x, y: line_4_y))
        ctx.addLine(to: CGPoint(x: line_5_x, y: line_5_y))
        ctx.addLine(to: CGPoint(x: line_6_x, y: line_6_y))
        
        
        // 结束绘制
        ctx.closePath()
        // 设置填充色
        ctx.setFillColor(Colors.backgroundColor.coloree.cgColor)
        // 去填多边形背景色
        ctx.fillPath()
        
        
    }
    
    
    /// 绘制界面
    private func setUI(){
        
        // 先把所有子视图都干掉
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        // 是否有点赞视图
        var haveLike:Bool = false
        // 是否有评论视图
        var haveComment:Bool = false
        
        // 有过有点赞的数据的话，展示点赞的数据
        if let likeData = likeData, likeData.count > 0 {
            
            haveLike = true
            self.addSubview(likeView)
            
            // 绘制点赞人名的集合
            var finalLikeString:String = "\(IconFont(code: IconFontType.心.rawValue).labelText) "
            for (index,data) in likeData.enumerated() {
                let name = data["name"] as? String ?? "--"
                finalLikeString +=  index == 0 ? name : "，\(name)"
            }
            
            // 设置富文本，行间距
            let attributeText = NSMutableAttributedString.init(string: finalLikeString)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributeText.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, finalLikeString.utf16.count))
            likeView.attributedText = attributeText
            
            
            NSLayoutConstraint.activate([
                likeView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
                likeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                likeView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
            ])
        }
        
        // 如果评论有数据的话，展示评论的数据
        if let commentData = commentData, commentData.count > 0 {
            haveComment = true
            
            for v in commentView.subviews {
                v.removeFromSuperview()
            }
            
            // 点赞跟评论中间的分割线
            var lineView:UIView?
            if haveLike == true {
                lineView = UIView()
                lineView?.backgroundColor = Colors.backgroundColor.colordc
                lineView?.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(lineView!)
                
                NSLayoutConstraint.activate([
                    lineView!.leftAnchor.constraint(equalTo: self.leftAnchor),
                    lineView!.rightAnchor.constraint(equalTo: self.rightAnchor),
                    lineView!.topAnchor.constraint(equalTo: likeView.bottomAnchor, constant: 4),
                    lineView!.heightAnchor.constraint(equalToConstant: 1)
                    ])
            }
            
            
            self.addSubview(commentView)
            
            // 绘制一条一条的评论
            var lastView:UIView?
            for (index,data) in commentData.enumerated() {
                
                let name:String = data["name"] as? String ?? "--"
                let replyName = data["replyName"] as? String
                let content = data["content"] as? String ?? "--"
                
                // 最终一条评论的文案
                var finalContentStr = name
                if let replyName = replyName {
                    finalContentStr += "回复\(replyName)"
                }
                finalContentStr += "：\(content)"
                
                // 设置富文本，名字要显示成蓝色
                let attributeText = NSMutableAttributedString.init(string: finalContentStr)
                attributeText.addAttributes([.foregroundColor: Colors.themeColor.main3,.font:UIFont.boldSystemFont(ofSize: 14.0)], range: NSMakeRange(0, name.utf16.count))
                if let replyName = replyName {
                    attributeText.addAttributes([.foregroundColor: Colors.themeColor.main3,.font:UIFont.boldSystemFont(ofSize: 14.0)], range: NSMakeRange(name.utf16.count + 2, replyName.utf16.count))
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 2     //设置行间距
                attributeText.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, finalContentStr.utf16.count))
                
                
                let c = UILabel()
                c.textColor = Colors.fontColor.font333
                c.font = UIFont.systemFont(ofSize: 14.0)
                c.translatesAutoresizingMaskIntoConstraints = false
                c.numberOfLines = 0
                c.attributedText = attributeText
                c.isUserInteractionEnabled = true
                c.tag = 99 + index
                commentView.addSubview(c)
                
                // 给label添加点击事件
                let tap = UITapGestureRecognizer(target: self, action: #selector(commentClick))
                tap.numberOfTapsRequired = 1
                c.addGestureRecognizer(tap)

                let top = lastView == nil ? c.topAnchor.constraint(equalTo: commentView.topAnchor) : c.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant:4)

                NSLayoutConstraint.activate([
                    top,
                    c.leftAnchor.constraint(equalTo: commentView.leftAnchor),
                    c.rightAnchor.constraint(equalTo: commentView.rightAnchor)
                ])

                lastView = c
            }

            if let lastView = lastView {
                NSLayoutConstraint.activate([lastView.bottomAnchor.constraint(equalTo: commentView.bottomAnchor)])
            }
            
            let top = haveLike ? commentView.topAnchor.constraint(equalTo: lineView!.bottomAnchor, constant: 4) : commentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
            
            
            NSLayoutConstraint.activate([
                top,
                commentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
                commentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6)
                ])
        }
        
        
        if haveComment == true {
            NSLayoutConstraint.activate([commentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)])
        }else if haveLike == true {
            NSLayoutConstraint.activate([likeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)])
        }
    }
    
    
    /// 评论回复点击事件
    @objc private func commentClick(sender:UITapGestureRecognizer){
        if let cb = commentClickBlock, let data = commentData {
            cb(data[sender.view!.tag - 99])
        }
    }
    
}


