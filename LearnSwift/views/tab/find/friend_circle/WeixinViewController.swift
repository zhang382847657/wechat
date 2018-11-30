//
//  WeixinViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools
import CTNetworkingSwift

/// 朋友圈
class WeixinViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /// TableView
    @IBOutlet weak var tableView: UITableView!
    
    static let notificationName_refresh = "WeixinViewController_refresh"
    
    
    /// 联系人ApiManager
    private lazy var wxFriendCircleApiManager:WXFriendCircleApiManager = {
        let m = WXFriendCircleApiManager.init()
        m.delegate = self
        return m
    }()
    
    private lazy var wxFriendCircleReform:WXFriendCircleReform = {
        let r = WXFriendCircleReform()
        return r
    }()
    
    
    /// 动态数据
    private var dataList:[WeixinCellModel] = []
    
    /// 头部视图
    private var headerView:UIView!
    
    /// 记录某一行全文是否展开
    private var showAll:Bool?
    
    /// 导航栏右侧相机按钮
    private lazy var cameraImageView:UIImageView = {
        
        // 导航栏相机按钮
        let cameraImageView = UIImageView(image: IconFont(code: IconFontType.相机.rawValue, name:kIconFontName, fontSize: 20.0, color: UIColor.white).iconImage)
        cameraImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cameraImageView.isUserInteractionEnabled = true
        // 添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(cameraClick))
        cameraImageView.addGestureRecognizer(tap)
        // 添加长按事件
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(wordFriendCircle))
        longTap.minimumPressDuration = 1.0
        longTap.numberOfTouchesRequired = 1
        cameraImageView.addGestureRecognizer(longTap)
        return cameraImageView
    }()
    
    
    /// 唯一初始化
    required init() {
        super.init(nibName: "WeixinViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏右侧相机
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraImageView)
        
        // 初始化头部视图
        setupHeaderView()
        // 设置tableview的headerView
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 200
        
        
   
        // 添加头部刷新
        tableView.addHeaderRefresh(headerView: FriendCircleRefreshView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height + 20 + 30)), actionTarget: self, action: #selector(refresh))
        // 添加尾部加载更多
        tableView.addFooterLoadMore(actionTarget: self, action: #selector(loadMore))

        // 一进来就刷新
        tableView.beginRefresh()
        
        
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
  
        // 注册刷新的通知
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: WeixinViewController.notificationName_refresh), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        // 移除刷新组件的监听
        tableView.removeRefreshObserver()
        // 移除所有监听
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 相机点击
    @objc private func cameraClick() {
        
    }

    
    /// 刷新操作
    @objc private func refresh(){
        wxFriendCircleApiManager.loadData()
    }
    
    /// 上拉加载更多
    @objc private func loadMore(){
        wxFriendCircleApiManager.loadNextPage()
    }
    
    
    /// 弹出纯文字的朋友圈编辑页面
    @objc private func wordFriendCircle(tap:UIGestureRecognizer){
        if tap.state != .began {
            return
        }
        
        let nvc = PublishTextViewController.getViewController()
        self.present(nvc, animated: true, completion: nil)
    }
    
    
    /// 设置头部视图
    /// - 注意tableView的tableheaderView只能通过frame才能正确的计算头部视图的位置，如果用约束来创建的话，需要以下方法才能创建成功
    private func setupHeaderView(){
        
        // 如果头部视图是用代码约束创建的，最好再外面包一层View，这样能很好的把最外层的View撑开
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: 1))
        
        
        // 创建真正的头部视图
        let weixinHeaderView = WeixinHeaderView(name: "张琳", frame: CGRect.zero)
        headerView.addSubview(weixinHeaderView)
        weixinHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 添加约束，让真正的头部视图撑满最外面的headerView
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":weixinHeaderView]))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":weixinHeaderView]))
        
        
        // 重新计算真实的头部视图的高度，修复headerView的frame
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
    
    }
    
    
    //MARK: UITableView - DataSource
    
    /// 返回几组
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// 返回每组有几行
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    

    /// 绘制Cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell:WeixinCell = WeixinCell.getCell(tableView: tableView, viewModel: dataList[indexPath.row])
        
        cell.viewModel.rowHeight = cell.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel).height
        
        
        if let showAll = showAll {
            cell.viewModel.showAll = showAll
        }
        
        
        // 全文/收起按钮点击回调
        cell.btnCallBack = { [weak self] (isSelect:Bool) -> Void in
            self?.showAll = isSelect
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        // 操作按钮点击回调
        cell.commentClickBack = { [weak self] (sender:UIButton) in
            
            
            let pop =  CommentPopoverController(sourceView: sender, dynamicId: cell.viewModel.id, isLike: cell.viewModel.isLike, likeClickBack: { [weak self](isLike) in
                
                cell.viewModel.isLike = isLike
               
                if var likesData = cell.viewModel.likesData, let wxId = User.share.wxId {
                    
                    if isLike == true {
                        
                        likesData.append(["name":User.share.name ?? "","wxId":wxId])
                        
                    } else {
                        for (index,value) in likesData.enumerated() {
                            if value["wxId"] as! String == wxId {
                                likesData.remove(at: index)
                                break
                            }
                        }
                    }
                    
                    cell.viewModel.likesData = likesData
                }
    
                self?.dataList[indexPath.row] = cell.viewModel
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                
            }, commentClickBack: { //评论点击回调
                
                // 显示评论的输入框
                ReplayTools.share.showReplayView(text: nil, tableView: tableView, cell: cell, sendClick: { (text) in
                    
                    // 添加一条评论
                    WXApi.dynamicAddComment(dynamicId: cell.viewModel.id, content: text, success: { [weak self](json) in
                        
                        if var commentData = cell.viewModel.commentData, let jsonDic = json.dictionaryObject {
                            commentData.append(jsonDic)
                            cell.viewModel.commentData = commentData
                            self?.dataList[indexPath.row] = cell.viewModel
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    }, failed: nil)
    
                })
                
            })
            self?.present(pop, animated: false, completion: nil)
        }
        
        // 回复评论点击回调
        cell.commentView.commentClickBlock = {[weak self] (data) in
            
            guard let weakSelf = self, let id = User.share.id, let userId = data["userId"] as? Int, let commentId = data["id"] as? Int else {
                return
            }
            
            
            if userId == id { //说明点击的是自己的评论，则就删除评论
                
                Alert.show(viewcontroller: weakSelf, title: "提示", message: "是否要删除此评论", done: {
                    WXApi.dynamicDeleteComment(commentId: commentId, success: { [weak self](_) in
                        
                        if var commentData = cell.viewModel.commentData {
                            for (index,value) in commentData.enumerated() {
                                if value["id"] as! Int == commentId {
                                    commentData.remove(at: index)
                                    break
                                }
                            }
                            cell.viewModel.commentData = commentData
                            self?.dataList[indexPath.row] = cell.viewModel
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                        }, failed: nil)
                })
                
                
            } else { //否则就是回复别人的评论
                
                
                ReplayTools.share.showReplayView(text: nil, placheolder: "回复\(data["name"] as? String ?? "--")", tableView: tableView, cell: cell, sendClick: { (text) in

                    
                    WXApi.dynamicReplyComment(dynamicId: cell.viewModel.id, replyUserId: userId, content: text, success: { [weak self](json) in
                        
                        if var commentData = cell.viewModel.commentData, let jsonDic = json.dictionaryObject {
                            commentData.append(jsonDic)
                            cell.viewModel.commentData = commentData
                            self?.dataList[indexPath.row] = cell.viewModel
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    }, failed: nil)
                })
                
            }
           
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = dataList[indexPath.row]
        return  viewModel.rowHeight ?? UITableViewAutomaticDimension
    }
    

    //MARK: UITableView Delegate

    //MARK: 点击Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 44

        // 导航栏的高度(导航栏+电池条)
        let navigationHeight = UIApplication.shared.statusBarFrame.height + navigationBarHeight
        // 渐变的高度
        let gradualHeight = headerView.frame.height - navigationHeight * 2

        if scrollView.contentOffset.y < gradualHeight {
            self.navigationItem.title = nil
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.setBackgroundImage( UIImage.imageWithColor(UIColor(hex: "#eeeeee", alpha: 0)), for: .default)
            cameraImageView.image = IconFont(code: IconFontType.相机.rawValue, name:kIconFontName, fontSize: 20.0, color: UIColor.white).iconImage
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraImageView)
            return
        }

        self.navigationController?.navigationBar.setBackgroundImage( UIImage.imageWithColor(UIColor(hex: "#eeeeee", alpha: (scrollView.contentOffset.y - gradualHeight)/navigationHeight)), for: .default)
        self.navigationItem.title = LanguageHelper.getString(key: LanguageKey.朋友圈.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.themeColor.main2,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = Colors.themeColor.main2
        cameraImageView.image = IconFont(code: IconFontType.相机.rawValue, name:kIconFontName, fontSize: 20.0, color: Colors.themeColor.main2).iconImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraImageView)

    }


}

extension WeixinViewController : CTNetworkingBaseAPIManagerCallbackDelegate {
    func requestDidSuccess(_ apiManager: CTNetworkingBaseAPIManager) {
        
        guard let currentDataList = apiManager.fetch(reformer: wxFriendCircleReform) as? [WeixinCellModel] else {
            return
        }
        
        if wxFriendCircleApiManager.isFirstPage {
            tableView.endRefresh()
            dataList = []
            wxFriendCircleApiManager.isFirstPage = false
        }else{
            if wxFriendCircleApiManager.isLastPage {
                tableView.endLoadMoreWithNoData()
            }else{
                tableView.endLoadMore()
            }
        }
        
        dataList += currentDataList
        tableView.reloadData()
    }
    
    func requestDidFailed(_ apiManager: CTNetworkingBaseAPIManager) {
        tableView.endRefresh()
        tableView.endLoadMore()
    }
}


