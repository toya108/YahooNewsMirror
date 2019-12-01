//
//  NewsType.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/18.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation

/// ニュースの種別
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
    
    /// RSS取得用url
    /// - note: RSSはXMLでデータを返しますが、より汎用的に使えるJSONで記事を取得したいのでJSON変換するAPIを通しています。
    ///         https://rss2json.com/#rss_url=https%3A%2F%2Fwww.theguardian.com%2Finternational%2Frss
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
    
    /// ページメニュータイトル用文字列
    var itemInfo: String {
        switch self {
        case .main: return "主要"
        case .grobal: return "国際"
        case .entertainment: return "エンタメ"
        case .informationTechnology: return "IT"
        case .local: return "地域"
        case .domestic: return "国内"
        case .economics: return "経済"
        case .sports: return "スポーツ"
        case .science: return "科学"
        }
    }
}
