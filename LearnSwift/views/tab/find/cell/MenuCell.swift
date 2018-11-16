//
//  MenuCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class MenuCell: UITableViewCell {
    
    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    var data:Dictionary<String,Any> = [:] {
        didSet{
            updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    private func updateUI(){
        let iconfont:String? = data["iconfont"] as? String
        let iconColor:String? = data["iconColor"] as? String
        let title = data["title"] as! LanguageKey
        let iconImage:String? = data["iconImage"] as? String
        
        if let iconImage = iconImage {
            iconImageView.image = UIImage(named: iconImage)
        }else {
            iconImageView.image = IconFont(code: iconfont!, name:kIconFontName, fontSize: 26, color: UIColor(hex: iconColor!)).iconImage
        }
        
        titleLabel.text = LanguageHelper.getString(key: title.rawValue)
        
    }
    
}
