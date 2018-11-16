//
//  UserDetailHeaderCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class UserDetailHeaderCell: UITableViewCell {

    /// 头像
    @IBOutlet weak var headerImageView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 性别
    @IBOutlet weak var sexLabel: UILabel!
    /// 微信号
    @IBOutlet weak var weixinNumberLabel: UILabel!
    /// 昵称
    @IBOutlet weak var nickNameLabel: UILabel!
    
    
    var data:Dictionary<String,Any> = [:] {
        didSet{
            updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImageView.setCornerRadio(radio: 5)
        sexLabel.font = UIFont(name: kIconFontName, size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateUI(){
        let imageUrl = data[kWXUserDetailImageUrl] as? String
        let name = data[kWXUserDetailName] as! String
        let weixinNumber = data[kWXUserDetailWeixinNumber] as! String
        let sex:Int = data[kWXUserDetailSex] as? Int ?? 0 //性别 0女  1男 2未知
        let remarkName = data[kWXUserDetailRemarkName] as? String
        
        headerImageView.setImage(withUrl: imageUrl, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        nameLabel.text = remarkName != nil ? remarkName : name
        weixinNumberLabel.text = "微信号：\(weixinNumber)"
        nickNameLabel.text = remarkName == nil ? nil : "昵称：\(name)"
        
        if sex == 0 {
            sexLabel.text = IconFontType.女.rawValue
            sexLabel.textColor = UIColor(hex: "#F30000")
        }else if sex == 1 {
            sexLabel.text = IconFontType.男.rawValue
            sexLabel.textColor = UIColor(hex: "#007AFF")
        }else{
            sexLabel.text = nil
        }
    }
    
}
