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
class WeixinViewController: UIViewController {
    
    /// 通知刷新key名
    static let notificationName_refresh = "WeixinViewController_refresh"
    
    /// 唯一初始化
    required init() {
        super.init(nibName: "WeixinViewController", bundle: nil)
    }
    
    
    /// TableView
    @IBOutlet weak var tableView: UITableView!
    
    /// 朋友圈动态ApiManager
    private lazy var wxFriendCircleApiManager:WXFriendCircleApiManager = {
        let m = WXFriendCircleApiManager.init()
        m.delegate = self
        return m
    }()
    
    /// 朋友圈数据处理中心
    private lazy var wxFriendCircleReform:WXFriendCircleReform = {
        let r = WXFriendCircleReform()
        return r
    }()
    
    
    /// 头部视图
    private lazy var headerView:WeixinHeaderView =  {
        let h = WeixinHeaderView()
        h.translatesAutoresizingMaskIntoConstraints = false
        return h
    }()
    
    
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
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏右侧相机
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraImageView)
        
        // 设置头部视图
        tableView.tableHeaderView = headerView
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
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
    
}


//MARK: 业务相关
extension WeixinViewController {
    
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
    
    
    /// 计算头部视图并更新布局
    private func sizeHeaderToFit(){
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        // 立马布局子视图
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        // 重新设置tableHeaderView
        tableView.tableHeaderView = headerView
    }
}

//MARK: UITableView - DataSource
extension WeixinViewController : UITableViewDataSource {
    /// 返回几组
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// 返回每组有几行
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return wxFriendCircleReform.dataSource.count
    }
    
    
    /// 绘制Cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:WeixinCell = WeixinCell.getCell(tableView: tableView, indexPath: indexPath, viewModel: wxFriendCircleReform.dataSource[indexPath.row])
        cell.delegate = self
        cell.viewModel.rowHeight = cell.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel).height
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = wxFriendCircleReform.dataSource[indexPath.row]
        return  viewModel.rowHeight ?? UITableViewAutomaticDimension
    }
}


//MARK: UITableView Delegate
extension WeixinViewController : UITableViewDelegate {
    
}


//MARK: UIScrollView Delegate
extension WeixinViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 44
        
        // (导航栏+电池条)的高度
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

//MARK: 朋友圈动态协议
extension WeixinViewController: WeixinCellDelegate {

    /// 全文/收起按钮点击回调
    func contentShowAll(showAll: Bool, viewModel:WeixinCellModel, indexPath: IndexPath) {
        wxFriendCircleReform.dataSource[indexPath.row].showAll = showAll
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 展示点赞/评论模块
    func showCommentPopoverController(popView:CommentPopoverController){
        present(popView, animated: false, completion: nil)
    }
    
    /// 点赞
    func chooseLike(viewModel:WeixinCellModel, indexPath:IndexPath){
        wxFriendCircleReform.dataSource[indexPath.row] = viewModel
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 评论
    func sendComment(viewModel:WeixinCellModel, indexPath:IndexPath){
        wxFriendCircleReform.dataSource[indexPath.row] = viewModel
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 回复评论
    func replyComment(viewModel: WeixinCellModel, indexPath: IndexPath) {
        wxFriendCircleReform.dataSource[indexPath.row] = viewModel
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 删除评论
    func deleteComment(viewModel: WeixinCellModel, indexPath: IndexPath) {
        wxFriendCircleReform.dataSource[indexPath.row] = viewModel
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}



//MARK: API成功/失败回调
extension WeixinViewController : CTNetworkingBaseAPIManagerCallbackDelegate {
    func requestDidSuccess(_ apiManager: CTNetworkingBaseAPIManager) {
        
        guard (apiManager.fetch(reformer: wxFriendCircleReform) as? [WeixinCellModel]) != nil else {
            return
        }
        
        if wxFriendCircleApiManager.isFirstPage {
            tableView.endRefresh()
            wxFriendCircleApiManager.isFirstPage = false
        }else{
            if wxFriendCircleApiManager.isLastPage {
                tableView.endLoadMoreWithNoData()
            }else{
                tableView.endLoadMore()
            }
        }
        
        tableView.reloadData()
    }
    
    func requestDidFailed(_ apiManager: CTNetworkingBaseAPIManager) {
        tableView.endRefresh()
        tableView.endLoadMore()
    }
}



