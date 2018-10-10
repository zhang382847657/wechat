//
//  UserDetailPhotoCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class UserDetailPhotoCell: UITableViewCell {
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 第一个图
    @IBOutlet weak var firstImageView: UIImageView!
    /// 第二个图
    @IBOutlet weak var twoImageView: UIImageView!
    /// 第三个图
    @IBOutlet weak var threeImageView: UIImageView!
    /// 第四个图
    @IBOutlet weak var fourImageView: UIImageView!
    
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
        let imageUrls = data["imageUrls"] as? Array<String> ?? []
        
        titleLabel.text = title
        
        if imageUrls.count > 0 {
            firstImageView.setNetWrokUrl(imageUrl: imageUrls.first!)
        }
        if imageUrls.count > 1 {
            twoImageView.setNetWrokUrl(imageUrl: imageUrls[1])
        }
        if imageUrls.count > 2 {
            threeImageView.setNetWrokUrl(imageUrl: imageUrls[2])
        }
        if imageUrls.count > 3 {
            fourImageView.setNetWrokUrl(imageUrl: imageUrls[3])
        }
    }
    
}
