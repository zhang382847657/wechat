//
//  UserDetailDefaultCell.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/3.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class UserDetailDefaultCell: UITableViewCell {
    
    
    static let identifier = "UserDetailDefaultCell"
    
    
    /// 唯一获取Cell方法
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - viewModel: 视图模型
    /// - Returns: UserDetailHeaderCell
    public class func getCell(tableView:UITableView, viewModel:UserDetailDefaltViewModel) -> UserDetailDefaultCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserDetailDefaultCell
        if cell == nil {
            cell = UIView.loadViewFromNib(nibName: identifier) as? UserDetailDefaultCell
        }
        cell!.viewModel = viewModel
        return cell!
    }
    
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subTitleLabe: UILabel!
    /// 视图模型
    private var viewModel:UserDetailDefaltViewModel! {
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
        titleLabel.text = viewModel.title
        subTitleLabe.text = viewModel.subTitle
        self.accessoryType = viewModel.accessoryType
    }
    
}
