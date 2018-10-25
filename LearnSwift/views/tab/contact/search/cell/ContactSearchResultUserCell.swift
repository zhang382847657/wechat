//
//  ContactSearchResultUserCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class ContactSearchResultUserCell: UITableViewCell {

    ///  多图头像
    @IBOutlet weak var groupImageView: GroupImageView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subTitleLabel: UILabel!
    /// 标题与副标题之间的间距
    @IBOutlet weak var margin: NSLayoutConstraint!
    /// 数据
    var data:Dictionary<String,Any> = [:] {
        didSet{
          updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 代码添加分割线
        contentView.addBottomLineWith(color: Colors.backgroundColor.colordc)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 更新视图
    private func updateUI(){
        let images = data["images"] as! Array<String>
        let title = data["title"] as! String
        let subTitle = data["subTitle"] as? String
        
        groupImageView.imageUrls = images
        titleLabel.text = title
        subTitleLabel.text = subTitle
        margin.constant = subTitle != nil ? 2 : 0

        
    }
    
    
    
}
