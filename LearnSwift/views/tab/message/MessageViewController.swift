//
//  MessageViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/9/1.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit
import WXTools

class MessageViewController: UITableViewController {
    
    /// 搜索控制器
    private var searchController:ContactSearchController!
    private let cell_messageCell = "MessageCell"
    
    
    private var dataSource = [
        ["imageUrls":["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2959119197,2886529201&fm=27&gp=0.jpg"],"title":"臭脚广志","subTitle":"yeah 路上小心","time":"17:05","dnd":false],
        ["imageUrls":["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535803184946&di=982d416d9bc923c6af7861e6ec2ecd6d&imgtype=0&src=http%3A%2F%2Fcdnimg103.lizhi.fm%2Fradio_cover%2F2016%2F02%2F26%2F26707418492972420_320x320.jpg"],"title":"腾讯新闻","subTitle":"飞机空投数千鱼苗 网友惊呼太疯狂了","time":"15:52","dnd":false],
        ["imageUrls":["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535803264924&di=a7908a9940b75689a1dcf9e1619d1a4f&imgtype=0&src=http%3A%2F%2Fresources.51camel.com%2FWechatArticle%2FNews%2F2017%2F04-30%2F636291307401687183.png"],"title":"订阅号消息","subTitle":"[2条]CSDN:5个步骤，教你瞬间明白线程的方法是什么","time":"16:12","dnd":false],
        ["imageUrls":["https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2992756895,3309660940&fm=26&gp=0.jpg"],"title":"周鑫","subTitle":"😁，玩吃鸡喊上我啊！","time":"16:12","dnd":false],
        ["imageUrls":["https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2832797993,2676010642&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3279652966,1587444762&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2696032016,174188812&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3510006133,2153353159&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=400956165,4222403670&fm=26&gp=0.jpg"],"title":"都给我滚出来","subTitle":"都让一让，最近我很迷的up主","time":"2018?8/31","dnd":true],
        ["imageUrls":["https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3039902924,1574097504&fm=26&gp=0.jpg"],"title":"张俊操","subTitle":"(•́へ•́╬)","time":"2018/8/31","dnd":false],
        ["imageUrls":["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535803546653&di=0621e8b9721b30eae0361bb8c51f833f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170721%2F010e8a47d6364a5d8506a09214412174.jpeg"],"title":"中通快递","subTitle":"快件发出提醒","time":"2018/8/30","dnd":true],
        ["imageUrls":["https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=780806877,3837184441&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1056540682,2612336427&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3588001417,338267751&fm=26&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=411656538,4004991757&fm=26&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2680397869,2349365267&fm=26&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3582680,595140499&fm=11&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=468291768,128863658&fm=11&gp=0.jpg"],"title":"🐴小小澳洲代购群","subTitle":"Buling🌺:[捂脸]","time":"2018/8/30","dnd":true],
        ["imageUrls":["https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1509469201,2289552148&fm=11&gp=0.jpg"],"title":"冯文祥","subTitle":"😯","time":"2018/8/29","dnd":false],
        ["imageUrls":["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=665676765,3754099617&fm=11&gp=0.jpg"],"title":"寄养家庭","subTitle":"麻烦你啦，不打扰啦","time":"2018/8/27","dnd":false],
        ["imageUrls":["https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3302689525,4080875463&fm=11&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=740586216,516621802&fm=11&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4067590127,1858208029&fm=11&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3138965551,878422591&fm=11&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2464434866,2601464021&fm=11&gp=0.jpg"],"title":"邻里互助协会","subTitle":"BM001杨燕：[谢谢]","time":"2018/8/25","dnd":true],
    ]
    
    
    /// 唯一初始化
    required init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LanguageHelper.getString(key: LanguageKey.消息.rawValue)
        
        // 导航栏右侧加号
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IconFont(code: IconFontType.添加.rawValue, name:kIconFontName, fontSize: 20, color: UIColor.white).iconImage, style: .plain, target: self, action: #selector(addClick))
    
        // 注册Cell
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cell_messageCell)
        
        tableView.tableFooterView = UIView()
    
        // 搜索框
        searchController = ContactSearchController(tableView: tableView, viewController: self)
        //设置definesPresentationContext为true，我们保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上。
        self.definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView?.backgroundColor = UIColor.groupTableViewBackground
        
        // 设置背景色
        let tableBackgroundView = UIView(frame: tableView.bounds)
        tableBackgroundView.backgroundColor = UIColor.white
        tableView.backgroundView = tableBackgroundView
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// 导航栏加号点击
    @objc private func addClick(sender:UIBarButtonItem){
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageCell = tableView.dequeueReusableCell(withIdentifier: cell_messageCell, for: indexPath) as! MessageCell
        cell.data = dataSource[indexPath.row]
        return cell
    }
   
}
