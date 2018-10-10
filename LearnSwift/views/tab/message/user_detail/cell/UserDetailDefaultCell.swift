//
//  UserDetailDefaultCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class UserDetailDefaultCell: UITableViewCell {
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subTitleLabe: UILabel!
    
    
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
        let title = data["title"] as! String
        let subTitle = data["subTitle"] as? String
        let showArrow = data["showArrow"] as? Bool ?? false
        
        titleLabel.text = title
        subTitleLabe.text = subTitle
        self.accessoryType = showArrow ? .disclosureIndicator : .none
    }
    
}
