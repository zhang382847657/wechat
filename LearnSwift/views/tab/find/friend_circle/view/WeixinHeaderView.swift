//
//  WeixinHeaderView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/26.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import HomeKit

class WeixinHeaderView: UIView {
    
    /// 背景图片
    private var backgroundImageView:UIImageView!
    /// 头像
    private var headerImageView:UIImageView!
    /// 名字
    private var nameLabel:UILabel!
    
    init(name:String ,frame:CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        /// 代码约束步骤
        /// 1. 创建视图对象
        /// 2. 设置视图属性
        /// 3. translatesAutoresizingMaskIntoConstraints设为false，禁止系统自动布局，改成手动约束
        /// 4. addSubView添加到父视图上
        /// 5. 添加约束
        
        backgroundImageView = UIImageView()
        backgroundImageView.setNetWrokUrl(imageUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535621957358&di=56ef141ea014899abab63c64827e77da&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D154725362%2C2173450029%26fm%3D214%26gp%3D0.jpg")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        self.addSubview(backgroundImageView)
        
        
        headerImageView = UIImageView()
        headerImageView.setNetWrokUrl(imageUrl: "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=71246494,232197247&fm=26&gp=0.jpg")
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.layer.borderColor = Colors.backgroundColor.colordc.cgColor
        headerImageView.layer.borderWidth = 1.0
        self.addSubview(headerImageView)
        
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        nameLabel.text = "琳"
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        
        
        
/*        /// 方法一： 调用addConstraints添加约束
        /// 优点：语法支持所有版本  缺点：需要自己判断约束添加到谁上面，代码量大
        let centerX = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
         
        let centerY = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
        
        let hight = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0.25, constant: 0)


        let blue_hight = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 50)

        let blue_width = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: blueView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)
        
        blueView.addConstraints([blue_hight,blue_width])
        self.addConstraints([centerX,centerY,hight])
 */


        /// 方法二(推荐)：Anchor写法直接添加约束  NSLayoutConstraint.activate，
        /// 优点：代码简洁明了     缺点：ios9以上才支持的写法
        
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -35),
            backgroundImageView.heightAnchor.constraint(equalToConstant: screenBounds.width * 0.9),
            backgroundImageView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -25),
            headerImageView.widthAnchor.constraint(equalToConstant: 77),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            headerImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            nameLabel.rightAnchor.constraint(equalTo: headerImageView.leftAnchor, constant: -18),
            nameLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 20)
        ])

        
        
/*        /// 方法三(推荐)： NSLayoutConstraint.activate 来添加所有的约束
        /// 优点：系统自己帮你判断约束添加到谁上面   缺点：ios9以上才支持的写法
        NSLayoutConstraint.activate([centerX,centerY,blue_hight,blue_width,hight])
 */
    
 
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



}
