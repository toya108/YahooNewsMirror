//
//  ViewController.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/16.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit

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

    var articles: [Item] = [] {
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
        
        guard let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Fpickup%2Frss.xml") else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            guard let articles = try?decoder.decode(ArticleList.self, from: data) else { return }
            DispatchQueue.main.async() { () -> Void in
                self.articles = articles.items
            }
        })
        
        task.resume()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row].title
        return cell
    }
}
