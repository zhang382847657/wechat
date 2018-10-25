//
//  WeixinViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/7/19.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

/// 朋友圈
class WeixinViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /// TableView
    @IBOutlet weak var tableView: UITableView!
    
    static let notificationName_refresh = "WeixinViewController_refresh"
    
    private var wxCell:WeixinCell!
    
    /// 动态数据
    private var dataList:[[String:Any]] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    /// 一页显示条数
    private let pageSize:Int = 10
    /// 页码
    private var pageNum:Int = 0
    
    /// 缓存行高
    private var rowHeightCache:[IndexPath:CGFloat] = [:]
    
    /// CellID
    private let weixinIdentifier:String = "weixinCell"
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
        
        
        // 用类名的方式注册Cell
        tableView.register(UINib(nibName: "WeixinCell", bundle: nil), forCellReuseIdentifier: weixinIdentifier)
        wxCell = tableView.dequeueReusableCell(withIdentifier: weixinIdentifier) as! WeixinCell
        // 初始化头部视图
        setupHeaderView()
        // 设置tableview的headerView
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 220
        
        // 添加头部刷新
        tableView.addHeaderRefresh(headerView: FriendCircleRefreshView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: UIApplication.shared.statusBarFrame.height + 44 + 20 + 30)), actionTarget: self, action: #selector(refresh))
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
    
    /// 加载数据
    private func loadData(isRefresh:Bool = true){
        
        if isRefresh {
            pageNum = 0
        }else {
            pageNum += 1
        }
        
        WXApi.dynamicList(pageNum: pageNum, pageSize: pageSize, success: { [weak self](json) in
            
            if isRefresh {
                self?.dataList = json["dataList"].arrayObject as? [[String : Any]] ?? []
                self?.tableView.endRefresh()
                if self?.dataList.count == json["totalCount"].intValue {
                    self?.tableView.endLoadMoreWithNoData()
                }
            }else {
                self?.dataList += json["dataList"].arrayObject as? [[String : Any]] ?? []
                if self?.dataList.count == json["totalCount"].intValue {
                    self?.tableView.endLoadMoreWithNoData()
                }else {
                    self?.tableView.endLoadMore()
                }
            }
            
        }) { [weak self](error) in
            
            self?.tableView.endRefresh()
            self?.tableView.endLoadMore()
            
            if var pn = self?.pageNum, pn > 0 {
                pn -= 1
            }
        }
        
    }
    
    /// 刷新操作
    @objc private func refresh(){
        loadData(isRefresh: true)
    }
    
    /// 上拉加载更多
    @objc private func loadMore(){
        loadData(isRefresh: false)
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
        
        let cell:WeixinCell = tableView.dequeueReusableCell(withIdentifier: weixinIdentifier, for: indexPath) as! WeixinCell
        
        // 获取数组中对应的值
        var dic = dataList[indexPath.row]
        
        if let showAll = showAll {
            dic["isSelect"] = showAll
        }
        
        // 更新数据源
        cell.setupUI(data: dic)
        
        // 全文/收起按钮点击回调
        cell.btnCallBack = { [weak self] (isSelect:Bool) -> Void in
            self?.showAll = isSelect
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        // 操作按钮点击回调
        cell.commentClickBack = { [weak self] (sender:UIButton) in
            
            
            let pop =  CommentPopoverController(sourceView: sender, dynamicId: dic["id"] as! Int, isLike: dic["isLike"] as! Bool, likeClickBack: { [weak self](isLike) in
                
                dic["isLike"] = isLike
               
                if var likesData = dic["likes"] as? [[String : Any]], let wxId = User.share.wxId {
                    
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
                    
                    dic["likes"] = likesData
                }
    
                self?.dataList[indexPath.row] = dic
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                
            }, commentClickBack: { //评论点击回调
                
                // 显示评论的输入框
                ReplayTools.share.showReplayView(text: nil, tableView: tableView, cell: cell, sendClick: { (text) in
                    
                    // 添加一条评论
                    WXApi.dynamicAddComment(dynamicId: dic["id"] as! Int, content: text, success: { [weak self](json) in
                        
                        if var commentData = dic["comment"] as? [[String : Any]], let jsonDic = json.dictionaryObject {
                            commentData.append(jsonDic)
                            dic["comment"] = commentData
                            self?.dataList[indexPath.row] = dic
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    }, failed: nil)
    
                })
                
            })
            self?.present(pop, animated: false, completion: nil)
        }
        
        // 回复评论点击回调
        cell.commentView.commentClickBlock = { (data) in
            
            guard let id = User.share.id, let userId = data["userId"] as? Int, let commentId = data["id"] as? Int else {
                return
            }
            
            
            if userId == id { //说明点击的是自己的评论，则就删除评论
                
                Alert.show(viewcontroller: self, title: "提示", message: "是否要删除此评论", done: {
                    WXApi.dynamicDeleteComment(commentId: commentId, success: { [weak self](_) in
                        
                        if var commentData = dic["comment"] as? [[String : Any]] {
                            for (index,value) in commentData.enumerated() {
                                if value["id"] as! Int == commentId {
                                    commentData.remove(at: index)
                                    break
                                }
                            }
                            dic["comment"] = commentData
                            self?.dataList[indexPath.row] = dic
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                        }, failed: nil)
                })
                
                
            } else { //否则就是回复别人的评论
                
                
                ReplayTools.share.showReplayView(text: nil, placheolder: "回复\(data["name"] as? String ?? "--")", tableView: tableView, cell: cell, sendClick: { (text) in

                    
                    WXApi.dynamicReplyComment(dynamicId: dic["id"] as! Int, replyUserId: userId, content: text, success: { [weak self](json) in
                        
                        if var commentData = dic["comment"] as? [[String : Any]], let jsonDic = json.dictionaryObject {
                            commentData.append(jsonDic)
                            dic["comment"] = commentData
                            self?.dataList[indexPath.row] = dic
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    }, failed: nil)
                })
                
            }
           
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if rowHeightCache.keys.contains(indexPath) {
            return rowHeightCache[indexPath]!
        }else {
            // 获取数组中对应的值
            var dic = dataList[indexPath.row]
            if let showAll = showAll {
                dic["isSelect"] = showAll
            }
            // 更新数据源
            wxCell.setupUI(data: dic)
            let cellHeight = wxCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1.0
            rowHeightCache[indexPath] = cellHeight
            return cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    //MARK: UITableView Delegate

    //MARK: 点击Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {


        // 导航栏的高度(导航栏+电池条)
        let navigationHeight = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
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
