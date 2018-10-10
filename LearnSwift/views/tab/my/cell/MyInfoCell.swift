//
//  MyInfoCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

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
        headerImageView.setNetWrokUrl(imageUrl: User.share.headPicture)
        qrImageView.image = IconFont(code: IconFontType.二维码.rawValue, fontSize: 20, color: Colors.fontColor.font999).iconImage
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
