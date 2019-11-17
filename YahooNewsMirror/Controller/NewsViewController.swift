//
//  ViewController.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/16.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip

/// ホーム画面
class NewsViewController: UITableViewController, IndicatorInfoProvider {
    
    // MARK: Properties
    
    /// タブメニュー編集用インスタンス
    var itemInfo = IndicatorInfo(title: "タブ名")
    /// ニュース種別
    var newsType: NewsType?
    /// 記事一覧
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Initializer
    
    init(newsType: NewsType, style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.newsType = newsType
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
        
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.estimatedRowHeight = 600.0
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        RssClient.fetchItems(urlString: self.newsType?.urlStr ?? "", completion: { (response) in
            switch response {
            case .success(let items):
                DispatchQueue.main.async() { () -> Void in
                    self.items = items
                }
            case .failure(let err):
                print("記事の取得に失敗しました: reason(\(err))")
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.titleLable.text = items[indexPath.row].title
        cell.pubDateLable.text = items[indexPath.row].pubDate
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
