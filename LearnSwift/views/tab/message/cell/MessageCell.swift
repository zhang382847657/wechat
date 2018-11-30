//
//  MessageCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var headerImageView: GroupImageView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subTitleLabe: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 免打扰
    @IBOutlet weak var dndLabel: UILabel!
    
    var data:Dictionary<String,Any> = [:] {
        didSet{
            updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dndLabel.font = UIFont(name: kIconFontName, size: 13.0)
//        headerImageView.setCornerRadio(radio: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateUI(){
        let imageUrls = data["imageUrls"] as! Array<String>
        let title = data["title"] as! String
        let subTitle = data["subTitle"] as? String
        let time = data["time"] as! String
        let dnd = data["dnd"] as! Bool
        
        headerImageView.imageUrls = imageUrls
        titleLabel.text = title
        subTitleLabe.text = subTitle
        timeLabel.text = time
        dndLabel.text = dnd ? IconFontType.免打扰.rawValue : nil
        
    }
    
}
