//
//  UserDetailPhotoCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

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
        let title = data[kWXUserDetailTitle] as! String
        let imageUrls = data[kWXUserDetailImageUrls] as? Array<String> ?? []
        
        titleLabel.text = title
        
        if imageUrls.count > 0 {
            firstImageView.setImage(withUrl: imageUrls.first!, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        }
        if imageUrls.count > 1 {
            twoImageView.setImage(withUrl: imageUrls[1], placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        }
        if imageUrls.count > 2 {
            threeImageView.setImage(withUrl: imageUrls[2], placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        }
        if imageUrls.count > 3 {
            fourImageView.setImage(withUrl: imageUrls[3], placeholderImage: IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage)
        }
    }
    
}
