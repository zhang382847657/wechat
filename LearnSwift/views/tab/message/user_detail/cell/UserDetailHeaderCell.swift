//
//  UserDetailHeaderCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import AlamofireImage

class UserDetailHeaderCell: UITableViewCell {
    
    
    static let identifier_userDetailHeader = "UserDetailHeaderCell"
    
    
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: UserDetailHeaderCell
    public class func getCell(tableView:UITableView, viewModel:UserDetailHeaderViewModel) -> UserDetailHeaderCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier_userDetailHeader) as? UserDetailHeaderCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier_userDetailHeader) as? UserDetailHeaderCell
        }
        cell!.viewModel = viewModel
        return cell!
    }
    

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
    /// 视图模型
    private var viewModel:UserDetailHeaderViewModel! {
        didSet{
            updateUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sexLabel.font = UIFont(name: kIconFontName, size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateUI(){
       
        
        headerImageView.setImage(withUrl: viewModel.headerImageUrl, placeholderImage: IconFont(code: IconFontType.图片.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, failedImage: IconFont(code: IconFontType.图片失效.rawValue, name:kIconFontName, fontSize: 15.0, color: Colors.backgroundColor.colordc).iconImage, filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: headerImageView.bounds.size, radius: 5))
        nameLabel.text = viewModel.name
        weixinNumberLabel.text = viewModel.wxNumber
        nickNameLabel.text = viewModel.nickName
        sexLabel.text = viewModel.sexTitle
        sexLabel.textColor = viewModel.sexColor
      
    }
    
}
