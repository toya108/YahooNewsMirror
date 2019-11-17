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

struct ArticleList: Codable {
    let status: String
    let feed: Feed
    let items: [Item]
}
struct Feed: Codable {
    let url: String
    let title: String
    let link: String
    let author: String
    let description: String
}
struct Item: Codable {
    let title: String
    let pubDate: String
    let link: String
    let guid: String
}

enum NewsType: CaseIterable {
    case main
    case grobal
    case entertainment
    case informationTechnology
    case local
    case domestic
    case economics
    case sports
    case science
    
    var urlStr: String {
        switch self {
        case .main:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .grobal:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fworld%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .entertainment:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fentertainment%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .informationTechnology:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fcomputer%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .local:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Flocal%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .domestic:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fdomestic%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .economics:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Feconomy%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .sports:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fsports%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        case .science:
        return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Fscience%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        }
    }
}

/// ホーム画面
class NewsViewController: UIViewController {
    var itemInfo: IndicatorInfo = "First"
    var newsType: NewsType?
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(newsType: NewsType) {
        self.newsType = newsType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RssClient.fetchItems(urlString: NewsType.main.urlStr, completion: { (response) in
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
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.titleLable.text = items[indexPath.row].title
        cell.pubDateLable.text = items[indexPath.row].pubDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
