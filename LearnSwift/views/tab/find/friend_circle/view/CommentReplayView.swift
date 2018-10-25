//
//  CommentReplayView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/8.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class CommentReplayView: UIView, UITextViewDelegate {

    /// 上半部分视图
    @IBOutlet weak var topView: UIView!
    /// 输入框
    @IBOutlet weak var textView: UITextView!
    /// 输入框高度
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    /// 表情/键盘切换按钮
    @IBOutlet weak var expressionBtn: UIButton!
    /// 下半部分视图
    @IBOutlet weak var bottomView: UIView!
    /// 输入框高度变化回调
    var textViewHeightChange:(()->Void)?
    /// 键盘发送按钮点击回调
    var sendClickCallBack:((String)->Void)?

    
    override func awakeFromNib() {
        
        // 输入框的样式
        textView.layer.borderColor = Colors.backgroundColor.coloree.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.delegate = self
        
        // 表情/键盘切换样式
        expressionBtn.setImage(IconFont.init(code: IconFontType.表情.rawValue, name:kIconFontName, fontSize: 30, color: Colors.fontColor.font999).iconImage, for: .normal)
        expressionBtn.setImage(IconFont.init(code: IconFontType.键盘.rawValue, name:kIconFontName, fontSize: 30, color: Colors.fontColor.font999).iconImage, for: .selected)
    }
    
    
    /// 表情/键盘切换点击
    @IBAction func expressionClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    

    /// 计算输入框文字真实的高度
    private func heightForTextView(textView:UITextView, withText strText:NSString) -> CGFloat {
        
        let constraint = CGSize(width: textView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = strText.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: 14.0)], context: nil)
        let textHeight = size.size.height + (30 - textView.font!.lineHeight)
        return textHeight
    }
    
    // MARK: UITextView - Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // 输入框高度
        var height:CGFloat = 0.0
        
        if text == "" { //如果是删除文字操作
            
            if textView.text != "" {
                height = heightForTextView(textView: textView, withText: textView.text.prefix(textView.text.count - 1) as NSString)
            }else{
                height = heightForTextView(textView: textView, withText: textView.text! as NSString)
            }
            
        }else if text == "\n" { //如果点击了键盘的发送按钮

            if let sendClickCallBack = sendClickCallBack {
                sendClickCallBack(textView.text)
            }
            textView.text = ""
            textView.resignFirstResponder()
            textViewHeight.constant = 30.0
            return false
            
        }else{ //如果是输入文字

            height = heightForTextView(textView: textView, withText: "\(textView.text!)\(text)" as NSString)
            
        }
        
        // 当输入框大于120，就不再继续增加高度了
        if height >= 120 {
            return true
        }
        
        self.textViewHeight.constant = height
        
        // 给约束加一个动画效果
        UIView.animate(withDuration: 0.5, animations: {
            
            guard let superView = self.superview else {
                return
            }
            
            superView.layoutIfNeeded()
            
            if let textViewHeightChange = self.textViewHeightChange {
                textViewHeightChange()
            }
            
        }, completion: nil)
    
        
        return true

        
    }
    
}
