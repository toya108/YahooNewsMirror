//
//  ArticleList.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/18.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation

/// RSSから取得する記事リスト
struct ArticleList: Codable {
    let status: String
    let feed: Feed
    let items: [Item]
}
/// フィード
struct Feed: Codable {
    let url: String
    let title: String
    let link: String
    let author: String
    let description: String
}
/// 記事詳細
struct Item: Codable {
    let title: String
    let pubDate: String
    let link: String
    let guid: String
}
