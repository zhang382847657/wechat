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
    
    static let identifier = "UserDetailPhotoCell"
    
    
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: UserDetailHeaderCell
    public class func getCell(tableView:UITableView, viewModel:UserDetailPhotoViewModel) -> UserDetailPhotoCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserDetailPhotoCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier) as? UserDetailPhotoCell
        }
        cell!.viewModel = viewModel
        return cell!
    }
    
    
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
    
    var viewModel:UserDetailPhotoViewModel! {
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
       
        let placeholderImage = IconFont(code: IconFontType.图片.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage
        let failedImage = IconFont(code: IconFontType.图片失效.rawValue, name: kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage
        
        titleLabel.text = viewModel.title
        
       
        firstImageView.setImage(withUrl: viewModel.firstImageUrl, placeholderImage: placeholderImage, failedImage: failedImage)
        
        twoImageView.setImage(withUrl: viewModel.secondImageUrl, placeholderImage: placeholderImage, failedImage: failedImage)
        
        threeImageView.setImage(withUrl: viewModel.thirdImageUrl, placeholderImage: placeholderImage, failedImage: failedImage)
        
        fourImageView.setImage(withUrl: viewModel.fourthImageUrl, placeholderImage: placeholderImage, failedImage: failedImage)
        
    }
    
}
