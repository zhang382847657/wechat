//
//  ContactUserCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class ContactUserCell: UITableViewCell {

    /// 头像
    @IBOutlet weak var headerImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 数据
    var data:Dictionary<String,Any> = [:] {
        didSet {
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
        
        let imageUrl = data["headPicture"] as? String
        let name = data["name"] as! String
        let remarkName = data["remarkName"] as? String
        
        headerImageView.setImage(withUrl: imageUrl, placeholderImage:  IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage:  IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        
        nameLabel.text = remarkName != nil ? remarkName : name
    }
    
}
