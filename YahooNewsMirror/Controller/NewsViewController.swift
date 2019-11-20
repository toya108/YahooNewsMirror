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
    
    /// セルの情報列挙体
    private enum CellInfo {
        case topArticleCell
        case articelCell
        
        var nibName: String {
            switch self {
            case .topArticleCell:
                return "TopArticleCell"
            case .articelCell:
                return "ArticleCell"
            }
        }
        
        var cellId: String {
            switch self {
            case .topArticleCell:
                return "TopArticleCell"
            case .articelCell:
                return "ArticleCell"
            }
        }
    }
    
    // MARK: Properties
    
    /// タブメニュー編集用インスタンス
    private var itemInfo = IndicatorInfo(title: "タブ名")
    /// ニュース種別
    private var newsType: NewsType = .main
    /// 記事一覧
    private var items: [Item] = [] {
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: CellInfo.articelCell.nibName,bundle: nil), forCellReuseIdentifier: CellInfo.articelCell.cellId)
        tableView.register(UINib(nibName: CellInfo.topArticleCell.nibName, bundle: nil), forCellReuseIdentifier: CellInfo.topArticleCell.cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RssClient.fetchItems(urlString: self.newsType.urlStr, completion: { (response) in
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
        
        // トップ記事用のセルを生成します。
        func configureTopArticleCell() -> TopArticleCell {
            let topArticleCell = tableView.dequeueReusableCell(withIdentifier: CellInfo.topArticleCell.cellId, for: indexPath) as! TopArticleCell
            topArticleCell.titleLable.text = items.first?.title
            topArticleCell.pubDateLabel.text = items.first?.pubDate
            let link = items.first?.link ?? ""
            RssClient.fetchThumnImgUrl(urlStr: link, completion: { response in
                switch response {
                case .success(let url):
                     // TODO: 画像のロードが遅すぎる。キャッシュに画像持たせるように修正したい。
                    topArticleCell.articleImage.sd_setImage(with: url, completed: nil)
                case .failure(let err):
                    print("HTMLの取得に失敗しました: reason(\(err))")
                    topArticleCell.articleImage.image = UIImage()
                }
            })
            return topArticleCell
        }
        
        // 記事表示用のセルを生成します。
        func configureArticleCell() -> ArticleCell {
            let articleCell = tableView.dequeueReusableCell(withIdentifier: CellInfo.articelCell.cellId, for: indexPath) as! ArticleCell
            
            articleCell.titleLable.text = items[indexPath.row].title
            articleCell.pubDateLable.text = items[indexPath.row].pubDate
            
            let link = items[indexPath.row].link
            RssClient.fetchThumnImgUrl(urlStr: link, completion: { response in
                switch response {
                case .success(let url):
                     // TODO: 画像のロードが遅すぎる。キャッシュに画像持たせるように修正したい。
                    articleCell.articleImage.sd_setImage(with: url, completed: nil)
                case .failure(let err):
                    print("HTMLの取得に失敗しました: reason(\(err))")
                    articleCell.articleImage.image = UIImage()
                }
            })
            return articleCell
        }
        
        // トップ記事のセルかどうか
        var isTopArticleCell: Bool {
            return indexPath.row == 0
        }
        
        guard isTopArticleCell else {
            return configureArticleCell()
        }
        return configureTopArticleCell()
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = items[indexPath.row].link
        let vc = DetailWebViewController(urlStr: link)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // トップ記事のセルかどうか
        var isTopArticleCell: Bool {
            return indexPath.row == 0
        }
        return isTopArticleCell ? 165 : 50
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension UIImage {
    public convenience init(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)!
            return
        } catch let err {
            print("UIImageの初期化に失敗しました: reason(\(err))")
        }
        self.init()
    }
}
