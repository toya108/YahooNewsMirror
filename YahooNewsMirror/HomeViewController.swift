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

/// ホーム画面
class HomeViewController: UIViewController {

    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        guard let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Frss.xml&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd") else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            guard let articles = try?decoder.decode(ArticleList.self, from: data) else { return }
            DispatchQueue.main.async() { () -> Void in
                print(articles)
                self.items = articles.items
            }
        })
        
        task.resume()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
