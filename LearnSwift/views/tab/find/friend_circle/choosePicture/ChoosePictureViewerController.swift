//
//  ChoosePictureViewerController.swift
//  LearnSwift_debug
//
//  Created by 张琳 on 2018/10/11.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

/// 选择图片/视频后的浏览器
class ChoosePictureViewerController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 图片数组
    private var pictureArray:[UIImage] = []
    /// 视频
    private var video:PHAsset?
    /// 视频播放器
    private var player:AVPlayer?
    /// 视频播放图层
    private var playerLayer:AVPlayerLayer?
    /// 播放按钮
    private lazy var playerBtn:UIButton = {
        let playBtn = UIButton(type: .custom)
        playBtn.setImage(IconFont(code: IconFontType.播放.rawValue, name:kIconFontName, fontSize: 60, color: UIColor.white).iconImage, for: .normal)
        playBtn.setImage(IconFont(code: IconFontType.暂停.rawValue, name:kIconFontName, fontSize: 60, color: UIColor.white).iconImage, for: .selected)
        playBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        playBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        // 让播放按钮不被视频所遮挡
        playBtn.layer.zPosition = .greatestFiniteMagnitude
        return playBtn
    }()
    /// 当前展示的图片下标
    private var currentIndex:Int = 0
    /// 图片被删除的回调
    private var pictureDelete:((Int)->Void)?
    /// 视频被删除的回调
    private var videoDelete:(()->Void)?

    /// 初始化图片浏览器
    ///
    /// - Parameters:
    ///   - pictureArray: 图片数组
    ///   - selectIndex: 展示第几张图  默认第一张
    ///   - pictureDelete: 图片被删除的回调
    init(pictureArray:[UIImage], selectIndex:Int = 0, pictureDelete:@escaping ((Int)->Void) = {_ in}) {
        self.pictureArray = pictureArray
        self.currentIndex = selectIndex
        self.pictureDelete = pictureDelete
        super.init(nibName: "ChoosePictureViewerController", bundle: nil)
    }
    
    
   

    /// 初始化视频浏览器
    ///
    /// - Parameters:
    ///   - video: 视频对象
    ///   - videoDelete: 视频被删除的回调
    init(video:PHAsset, videoDelete:@escaping (()->Void) = {}) {
        self.video = video
        self.videoDelete = videoDelete
        super.init(nibName: "ChoosePictureViewerController", bundle: nil)
    }
    
    
    /// 初始化视频浏览器
    ///
    /// - Parameter videoPath: 视频地址  可以是网络视频地址也可以是本地视频路径
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(currentIndex + 1)/\(video == nil ? pictureArray.count : 1)"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconFont(code: IconFontType.垃圾篓.rawValue, name:kIconFontName, fontSize: 24, color: UIColor.white).iconImage, style: .plain, target: self, action: #selector(deletePicture))
        
        
        if let video = video {
            
            let option = PHVideoRequestOptions()
            option.isNetworkAccessAllowed = true
            PHImageManager.default().requestPlayerItem(forVideo: video, options: option) { [weak self](playerItem, info) in
                
                guard let playerItem = playerItem, let weakself = self else {
                    return
                }
                
                /// 播放视频图层
                weakself.player = AVPlayer(playerItem: playerItem)
                weakself.playerLayer = AVPlayerLayer(player: weakself.player!)
                weakself.playerLayer?.frame = weakself.collectionView.bounds
                weakself.view.layer.addSublayer(weakself.playerLayer!)
                
                /// 添加播放按钮
                weakself.view.addSubview(weakself.playerBtn)
                
                /// 添加视频播放完的通知
                NotificationCenter.default.addObserver(weakself, selector: #selector(weakself.videoEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: weakself.player?.currentItem)

            }

            
        }else {
            
            // 注册Cell
            collectionView.register(ChoosePictureViewerCell.self, forCellWithReuseIdentifier: "ChoosePictureViewerCell")
            
            // 要加这一句才能让下面滚动到某一屏的代码生效
            self.view.layoutIfNeeded()
            // 滚动到某一屏
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
          
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerBtn.center = self.collectionView.center
        playerLayer?.frame = self.collectionView.frame
    }
    
   
    
    /// 删除图片/视频
    @objc private func deletePicture(){
        
        if let _ = video {
            self.videoDelete?()
            self.navigationController?.popViewController(animated: true)
        }else {
            pictureArray.remove(at: currentIndex)
            self.pictureDelete?(currentIndex)
        
            // 如果图片已经全部删完，就直接退出当前试图控制器
            if pictureArray.count == 0 {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            currentIndex = currentIndex - 1
            if currentIndex < 0 {
                currentIndex = 0
                self.navigationItem.title = "\(currentIndex + 1)/\(video == nil ? pictureArray.count : 1)"
            }
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
        
       
    }
    
    /// 播放/暂停视频
    @objc private func playVideo(sender:UIButton){
        guard let player = player else {
            return
        }
        let currentTime = player.currentItem?.currentTime()
        let durationTime = player.currentItem?.duration
        if player.rate == 0.0 {
            if currentTime?.value == durationTime?.value {
                player.currentItem?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            }
            player.play()
            sender.isSelected = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            player.pause()
            sender.isSelected = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    /// 视频播放结束
    @objc private func videoEnd(noti:NotificationCenter){

        guard let player = player else {
            return
        }
        
        player.pause()
        playerBtn.isSelected = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
  
    // MARK: UICollectionView datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChoosePictureViewerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePictureViewerCell", for: indexPath) as! ChoosePictureViewerCell
        cell.setUIWith(image: pictureArray[indexPath.item])
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            currentIndex =  Int(scrollView.contentOffset.x / scrollView.frame.width)
            self.navigationItem.title = "\(currentIndex + 1)/\(video == nil ? pictureArray.count : 1)"
        }
       
    }
  
}

