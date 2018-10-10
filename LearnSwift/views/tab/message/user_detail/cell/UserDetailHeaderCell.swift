//
//  UserDetailHeaderCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

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
        sexLabel.font = UIFont(name: IconFont.iconfontName, size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateUI(){
        let imageUrl = data["imageUrl"] as? String
        let name = data["name"] as! String
        let weixinNumber = data["weixinNumber"] as! String
        let sex:Int = data["sex"] as? Int ?? 0 //性别 0女  1男 2未知
        let remarkName = data["remarkName"] as? String
        
        headerImageView.setNetWrokUrl(imageUrl: imageUrl)
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
