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
    
    
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: WeixinCell
    public class func getCell(tableView:UITableView, viewModel:MenuModel) -> MenuCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier_menu) as? MenuCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier_menu) as? MenuCell
        }
        cell?.viewModel = viewModel
        return cell!
    }
    
    
    
    /// Cell唯一标识
    static let identifier_menu = "MenuCell"
    
    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel:MenuModel! {
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
        
        if let iconImage = viewModel.iconImage {
            iconImageView.image = UIImage(named: iconImage)
        }
        if let iconfont = viewModel.iconfont, let iconColor = viewModel.iconColor {
            iconImageView.image = IconFont(code: iconfont, name:kIconFontName, fontSize: 26, color: UIColor(hex: iconColor)).iconImage
        }
        if let title = viewModel.title {
            titleLabel.text = LanguageHelper.getString(key: title)
        }
    }
    
}
