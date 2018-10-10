//
//  ContactMenuCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class ContactMenuCell: UITableViewCell {

    /// 图标
    @IBOutlet weak var iconBtn: UIButton!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    var data:Dictionary<String,Any> = [:] {
        didSet {
            updateUI()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置图标圆角
        iconBtn.setCornerRadio(radio: 4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateUI(){
        let icon = data["icon"] as! String
        let bgColor = data["bgColor"] as! String
        let title = data["title"] as! LanguageKey
        
        iconBtn.backgroundColor = UIColor(hex: bgColor)
        iconBtn.setImage(IconFont(code: icon, fontSize: 15, color: UIColor.white).iconImage, for: .normal)
        titleLabel.text = LanguageHelper.getString(key: title)
    }
    
    
    
    
}
