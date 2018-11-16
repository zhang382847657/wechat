//
//  WeixinHeaderView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/26.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXNetWork
import WXTools

class WeixinHeaderView: UIView {
    
    /// 背景图片
    private lazy var backgroundImageView:UIImageView = {
        let i = UIImageView()
        i.setImage(withUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535621957358&di=56ef141ea014899abab63c64827e77da&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D154725362%2C2173450029%26fm%3D214%26gp%3D0.jpg", placeholderImage:  IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage:  IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    /// 头像
    private lazy var headerImageView:UIImageView = {
        let i = UIImageView()
        i.setImage(withUrl: "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=71246494,232197247&fm=26&gp=0.jpg", placeholderImage:  IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage:  IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFill
        i.layer.borderColor = Colors.backgroundColor.colordc.cgColor
        i.layer.borderWidth = 1.0
        return i
    }()
    
    /// 名字
    private lazy var nameLabel:UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.text = "琳"
        l.font = UIFont.systemFont(ofSize: 20.0)
        l.textColor = UIColor.white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    init(name:String ,frame:CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(backgroundImageView)
        addSubview(headerImageView)
        addSubview(nameLabel)
        
        
        let backgroundImageTop = backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -35)
        backgroundImageTop.priority = .defaultHigh
        
        let headerImageViewBottom =  headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32)
        headerImageViewBottom.priority = .defaultHigh
       
        
        NSLayoutConstraint.activate([
            backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
           backgroundImageTop,
            backgroundImageView.heightAnchor.constraint(equalToConstant: screenBounds.width * 0.9),
            backgroundImageView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -25),
            headerImageView.widthAnchor.constraint(equalToConstant: 77),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor),
           headerImageViewBottom,
            headerImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            nameLabel.rightAnchor.constraint(equalTo: headerImageView.leftAnchor, constant: -18),
            nameLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 20)
        ])

     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
