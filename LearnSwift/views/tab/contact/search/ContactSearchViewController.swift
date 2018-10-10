//
//  ContactSearchViewController.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/31.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

/// 搜索结果视图控制器
class ContactSearchResultViewController: UITableViewController,UISearchResultsUpdating {
    
    /// 是否开始搜索
    var startSearch:Bool = false {
        didSet{
            tableView.sectionHeaderHeight = startSearch ? 40.0 : 0.001
            tableView.sectionFooterHeight = startSearch ? 10.0 : 0.001
            self.tableView.reloadData()
        }
    }
    
    /// 搜索结果数据源
    private let dataSource = [
        ["title":"联系人",
         "value":[
            ["images":["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4240512315,2844108837&fm=26&gp=0.jpg"],"title":"奶牛侠"],
            ["images":["https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2480700010,1084521489&fm=26&gp=0.jpg"],"title":"音姐","subTitle":"昵称:小奶狗的大王"]
            ]
        ],
        ["title":"群聊",
         "value":[
            ["images":["https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2853825100,2915830781&fm=11&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1413277434,3150044815&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3000269986,2171130829&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2636600606,2053174170&fm=11&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2307339355,3100631120&fm=26&gp=0.jpg","https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3694250156,3986893103&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=615114797,3009214271&fm=27&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1958966202,1289193182&fm=27&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1934952861,3453579486&fm=27&gp=0.jpg"],"title":"8月14-20号迪拜采购(468)","subTitle":"包含:一只奶黄包"]]
        ],
        ["title":"聊天记录",
            "value":[
                ["images":["https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3394205655,2876624446&fm=26&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3549694042,3453710237&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4197256923,614232577&fm=26&gp=0.jpg"],"title":"🐴小小澳洲代购群~","subTitle":"37条相关聊天记录"],
                ["images":["https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3254591859,2280164611&fm=26&gp=0.jpg"],"title":"臭脚广志"]
            ]
        ]
    ]
    
    private let cell_contactSearchDefaultCell = "ContactSearchResultDefaultCell"
    private let cell_contactSearchResultUserCell = "ContactSearchResultUserCell"
    
    
    
    /// 唯一初始化
    ///
    /// - Parameter nav: 导航视图控制器
    required init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false //不加的话，table会下移
        }
        
        self.edgesForExtendedLayout = .init(rawValue: 0) //不加的话，UISearchBar返回后会上移
        
        tableView.backgroundColor = Colors.backgroundColor.main
        tableView.sectionHeaderHeight = 0.001
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag

        tableView.register(UINib(nibName: "ContactSearchResultDefaultCell", bundle: nil), forCellReuseIdentifier: cell_contactSearchDefaultCell)
        tableView.register(UINib(nibName: "ContactSearchResultUserCell", bundle: nil), forCellReuseIdentifier: cell_contactSearchResultUserCell)
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("section == \(startSearch ? dataSource.count : 1)")
        return startSearch ? dataSource.count : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = dataSource[section]["value"] as! Array<Dictionary<String,Any>>
        print("row == \(startSearch ? values.count : 1)")
        return startSearch ? values.count : 1
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if startSearch == true {
            let cell:ContactSearchResultUserCell = tableView.dequeueReusableCell(withIdentifier: cell_contactSearchResultUserCell, for: indexPath) as! ContactSearchResultUserCell
            let values = dataSource[indexPath.section]["value"] as! Array<Dictionary<String,Any>>
            cell.data = values[indexPath.row]
            cell.selectionStyle = .default
            return cell
        }else{
            let cell:ContactSearchResultDefaultCell = tableView.dequeueReusableCell(withIdentifier: cell_contactSearchDefaultCell) as! ContactSearchResultDefaultCell
            cell.selectionStyle = .none
            return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if startSearch == false {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dataSource[section]["title"] as? String
        label.textColor = Colors.fontColor.font666
        label.font = UIFont.systemFont(ofSize: 14.0)
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                                     label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 3)])
        view.addBottomLineWith()
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if startSearch {
//            let userDetailVC = UserDetailViewController()
//            presentingViewController?.navigationController?.pushViewController(userDetailVC, animated: true)
        }

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }

  
}
