//
//  ChoosePictureView.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/11.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

/// 选择照片/视频组件
/// 使用说明：
/// - 支持xib或者代码创建
/// - 获取最终选择好的图片或视频，直接调用 `selectedPhotos` 或者 `selectedAssets` 属性
class ChoosePictureView:UIView, TZImagePickerControllerDelegate {
    
    /// 添加按钮
    private lazy var addBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = Colors.backgroundColor.colorcc
        btn.setImage(IconFont(code: IconFontType.添加.rawValue, name:kIconFontName, fontSize: 40, color: Colors.fontColor.font666).iconImage, for: .normal)
        btn.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        btn.tag = 999
        self.addSubview(btn)
        return btn
    }()
    
    /// 选择好的图片/视频数组
    public var selectedPhotos:[UIImage] = []
    /// 选择好的相册数组
    public var selectedAssets:[PHAsset] = []

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    
    /// 布局UI
    private func setUI(){
        
        NSLayoutConstraint.activate([
            addBtn.topAnchor.constraint(equalTo: self.topAnchor),
            addBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
            addBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            addBtn.heightAnchor.constraint(equalTo: addBtn.widthAnchor)
        ])
        
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            addBtn.widthAnchor.constraint(equalToConstant: (self.frame.width - 8*2)/3.0 )
        ])
    }
    
    
    
    
    /// 添加照片/视频
    @objc private func addPicture(){
        
        let vc =  TZImagePickerController(maxImagesCount: 9, delegate: self)
        vc?.maxImagesCount = 9 - selectedPhotos.count
        vc?.videoMaximumDuration = 10
        
       
        
        let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "拍摄", style: .default) { (action) in
            
            
            vc?.allowTakePicture = true
            vc?.allowTakeVideo = true
            vc?.allowPickingImage = false
            vc?.allowPickingVideo = false
          
            UIViewController.getCurrentViewController().present(vc!, animated: true, completion: nil)
            
            
        }
        let albumAction = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            
            vc?.allowTakePicture = false
            vc?.allowTakeVideo = false
            vc?.allowPickingImage = true
            vc?.allowPickingVideo = true
            
            
            UIViewController.getCurrentViewController().present(vc!, animated: true, completion: nil)
            
        }
      
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            actionSheetVC.dismiss(animated: true, completion: nil)
        }
        actionSheetVC.addAction(cameraAction)
        actionSheetVC.addAction(albumAction)
        actionSheetVC.addAction(cancelAction)
        
        UIViewController.getCurrentViewController().present(actionSheetVC, animated: true, completion: nil)
        
        
    }
    
    /// 布局选择照片的九宫格界面
    private func setupChoosePictureUI(){
        
        self.removeConstraints(self.constraints)
        
        for v in self.subviews {
            if v.tag != 999 {
                v.removeFromSuperview()
            }
        }
        
        var lastView:UIButton?
        for (index,value) in selectedPhotos.enumerated() {
            
            
            let imageBtn = UIButton(type: .custom)
            
            if selectedAssets[index].mediaType == .video { //如果是视频类型
                imageBtn.setBackgroundImage(value, for: .normal)
                imageBtn.setImage(IconFont(code: IconFontType.播放.rawValue, name:kIconFontName, fontSize: 40, color: UIColor.white).iconImage, for: .normal)
                imageBtn.addTarget(self, action: #selector(videoClick), for: .touchUpInside)
            } else {
                imageBtn.contentHorizontalAlignment = .fill
                imageBtn.contentVerticalAlignment = .fill
                imageBtn.imageView?.contentMode = .scaleAspectFill
                imageBtn.setImage(value, for: .normal)
                imageBtn.addTarget(self, action: #selector(imageClick), for: .touchUpInside)
            }
            
            imageBtn.tag = 200 + index
            imageBtn.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(imageBtn)
            
            if let lastView = lastView {
                
                if index % 3 == 0 {
                    NSLayoutConstraint.activate([
                        imageBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
                        imageBtn.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 8)
                        ])
                    
                }else {
                    NSLayoutConstraint.activate([
                        imageBtn.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: 8),
                        imageBtn.topAnchor.constraint(equalTo: lastView.topAnchor)
                        ])
                }
                
            }else {
                NSLayoutConstraint.activate([
                    imageBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
                    imageBtn.topAnchor.constraint(equalTo: self.topAnchor)
                    ])
            }
            
            
            NSLayoutConstraint.activate([
                imageBtn.widthAnchor.constraint(equalTo: addBtn.widthAnchor),
                imageBtn.heightAnchor.constraint(equalTo: addBtn.heightAnchor)
                ])
            
            lastView = imageBtn
        }
        
        if selectedPhotos.count == 9 {
            
            NSLayoutConstraint.activate([
                lastView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
            addBtn.isHidden = true
            

        }else if selectedPhotos.count < 9 {
            
            // if selectedAssets.first!.mediaType == .video {
            //
            //            }
            
            if let lastView = lastView {
                if selectedPhotos.count % 3 == 0 {
                    NSLayoutConstraint.activate([
                        addBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
                        addBtn.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant:8),
                        addBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                    ])
                }else {
                    NSLayoutConstraint.activate([
                        addBtn.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: 8),
                        addBtn.topAnchor.constraint(equalTo: lastView.topAnchor),
                        lastView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                    ])
                }
            }else {
                setUI()
            }
            
            addBtn.isHidden = false

        }
        
        
        self.layoutIfNeeded()
    }
    
    /// 图片点击
    @objc private func imageClick(sender:UIButton){
        
        
        let vc =  ChoosePictureViewerController(pictureArray: selectedPhotos, selectIndex: sender.tag - 200) { [weak self](index) in //图片被删除的回调
            
            // 删除对应图片并重新布局
            self?.selectedPhotos.remove(at: index)
            self?.selectedAssets.remove(at: index)
            self?.setupChoosePictureUI()
        }
        UIViewController.getCurrentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 视频点击
    @objc private func videoClick(sender:UIButton){
       
        
        let vc = ChoosePictureViewerController(video: selectedAssets[sender.tag - 200]) {[weak self] in // 视频被删除的回调
            
            // 删除对应视频并重新布局
            self?.selectedPhotos.remove(at: 0)
            self?.selectedAssets.remove(at: 0)
            self?.setupChoosePictureUI()
        }
        UIViewController.getCurrentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK TZImagePickerController - Delegate
    
    // 选择好图片后
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        if let first = selectedAssets.first, first.mediaType == .video {
            selectedPhotos = photos
            selectedAssets = assets as! [PHAsset]
        }else {
            selectedPhotos += photos
            selectedAssets += assets as! [PHAsset]
        }
        setupChoosePictureUI()
    }
    
    // 选择好视频后
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        selectedPhotos = [coverImage]
        selectedAssets = [asset]
        setupChoosePictureUI()
    }
}
