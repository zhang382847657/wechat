//
//  MyInfoCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class MyInfoCell: UITableViewCell {

    /// 头像
    @IBOutlet weak var headerImageView: UIImageView!
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    /// 微信号
    @IBOutlet weak var weixinNumberLabel: UILabel!
    /// 二维码
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = User.share.name
        weixinNumberLabel.text = User.share.wxId
        headerImageView.setImage(withUrl: User.share.headPicture, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        qrImageView.image = IconFont(code: IconFontType.二维码.rawValue, name:kIconFontName, fontSize: 20, color: Colors.fontColor.font999).iconImage
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
