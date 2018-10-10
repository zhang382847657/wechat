//
//  ReplayTools.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/8.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit


/// 评论输入框工具类
/// 显示一个评论输入框，随键盘一起弹出/收起
class ReplayTools: NSObject {
    
    /// 单例
    static let share = ReplayTools()
    
    private var keyBoardBounds:CGRect!
    private let keyWindow = UIApplication.shared.keyWindow!
    private var replayViewBottomAnchor:NSLayoutConstraint?
    
    
    private var tableView:UITableView!
    private var cell:UITableViewCell!
    private var sendClick:((String)->Void)?
    
    
    /// 回复视图
    private lazy var replayView:CommentReplayView = {
        
        let v:CommentReplayView = UIView.loadViewFromNib(nibName: "CommentReplayView") as! CommentReplayView
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textViewHeightChange = { [weak self] in // 输入框高度变化回调
            self?.updateTableViewFrame()
        }
        v.sendClickCallBack = { [weak self](text) in // 输入框发送按钮点击回调
            if let cb = self?.sendClick {
                cb(text)
            }
        }
        keyWindow.addSubview(v)
        
        replayViewBottomAnchor = v.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
        
        NSLayoutConstraint.activate([
            v.leftAnchor.constraint(equalTo: keyWindow.leftAnchor),
            v.rightAnchor.constraint(equalTo: keyWindow.rightAnchor),
            replayViewBottomAnchor!
        ])
        
        keyWindow.layoutIfNeeded()
        
        return v

    }()
    
    override init() {
        super.init()
        
        // 监听键盘弹出和收起
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    /// 弹出回复视图
    ///
    /// - Parameters:
    ///   - indexPath: cell的indexPath
    ///   - heightChange: 高度变化回调
    func showReplayView(text:String? = nil,placheolder:String? = "评论",tableView:UITableView,cell:UITableViewCell,sendClick:((String)->Void)? = nil){
        
        self.tableView = tableView
        self.cell = cell
        self.sendClick = sendClick
        
        if let placheolder = placheolder {
            replayView.textView.setPlaceholder(placeholdStr: placheolder)
        }
        replayView.textView.text = text
        
        // 让输入框成为第一响应
        replayView.textView.becomeFirstResponder()
    }
    
    /// 键盘将要显示
    @objc private func keyBoardWillShow(note:NSNotification)
    {
        
        let userInfo  = note.userInfo! as NSDictionary
        keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        if let replayViewBottomAnchor = replayViewBottomAnchor {
            replayViewBottomAnchor.constant = -keyBoardBounds.size.height
        }
        
        let animations:(() -> Void) = { [weak self] in
            
            self?.keyWindow.layoutIfNeeded()
            self?.updateTableViewFrame()
        
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            
            animations()
        }
        
        
    }
    
    /// 键盘将要消失
    @objc private func keyBoardWillHide(note:NSNotification) {
        
        let userInfo  = note.userInfo! as NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        if let replayViewBottomAnchor = replayViewBottomAnchor {
            replayViewBottomAnchor.constant = keyBoardBounds.height
        }

        let animations:(() -> Void) = {
            self.keyWindow.layoutIfNeeded()
//            self?.updateTableViewFrame()
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))

            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion:nil)
            
        }else{
            
            animations()
        }
        
    }
    
    
    /// 更新TableView的内容偏移量
    private func updateTableViewFrame(){
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        // cell坐标转换到keyWindow坐标系上，为了跟回复视同转成一样的坐标系，好计算位置关系
        let cellReact:CGRect =  cell.convert(cell.bounds, to: keyWindow)
        
        // 如果cell的最下面位置被回复视图所遮挡，就让Cell往上移动到正好紧贴回复视图
        if cellReact.maxY > replayView.frame.origin.y {
            var beforeContentOffSize = tableView.contentOffset
            let moveSize:CGFloat = cellReact.maxY - replayView.frame.origin.y
            beforeContentOffSize.y += moveSize
            tableView.setContentOffset(beforeContentOffSize, animated: true)
        }
        
        
        print("react == \(cellReact)")
    }
    
}
