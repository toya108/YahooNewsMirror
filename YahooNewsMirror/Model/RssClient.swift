//
//  RssClient.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/17.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader

enum NetworkError: Error {
    // 不正なURLが指定されました。
    case invalidURL
    // 不正なレスポンスが返されました。
    case invalidResponse
    // 想定外のエラーです。
    case unknown
}
enum AppalicationError: Error {
    case parseFailed
    case unknown
}

/// RSS取得用クラス
class RssClient {
    
    /// RSSのフィードを取得します
    /// - Parameter urlString: 取得元RSSのurl
    /// - Parameter completion: 完了時の処理
    static func fetchFeed(urlString: String, completion: @escaping (Result<Feed, Error>) -> ()) {
        
         // URL型に変換できない文字列の場合は弾く
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            let decoder = JSONDecoder()
            guard let articleList = try?decoder.decode(ArticleList.self, from: data) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(articleList.feed))
        })
        task.resume()
    }
    
    /// 記事の一覧を取得します。
    /// - Parameter urlString: 取得元RSSのurl
    /// - Parameter completion: 完了時の処理
    static func fetchItems(urlString: String, completion: @escaping (Result<[Item], Error>) -> ()) {
        
         // URL型に変換できない文字列の場合は弾く
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            let decoder = JSONDecoder()
            guard let articleList = try?decoder.decode(ArticleList.self, from: data) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(articleList.items))
        })
        task.resume()
    }
    
    static func fetchThumnImgUrl(urlStr: String, completion: @escaping (Result<URL, Error>) -> ()) {
        // 入力したURLからHTMLのソースを取得する。
        guard let targetURL = URL(string: urlStr) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        do {
            // 入力したURLのページから、HTMLのソースを取得します。
            let sourceHTML = try String(contentsOf: targetURL, encoding: String.Encoding.utf8)
            
            let html = HTMLDocument(string: sourceHTML)
            // サムネイルの入ったエレメントを抜き出します。
            let htmlElement = html.firstNode(matchingSelector: "p[class^=\"tpcHeader_thumb_img\"]")
            // styleからサムネイルのurlを取得します。
            guard let style = htmlElement?.attributes["style"] else {
                completion(.failure(AppalicationError.unknown))
                return
            }
            // 無駄な文字列を削除して整形します。
            let imageUrlStr: String = {
                let startIndex = style.index(style.startIndex, offsetBy: 23)
                let endIndex = style.index(style.endIndex, offsetBy: -3)
                return String(style[startIndex..<endIndex])
            }()
            
            guard let imageUrl = URL(string: imageUrlStr) else {
                completion(.failure(AppalicationError.unknown))
                return
            }
            
            completion(.success(imageUrl))
        }
        catch {
            completion(.failure(error))
        }
    }
    

    
//    static func fetchImageFromHTML(urlStr: String) {
//        guard let url = URL(string: urlStr) else {
//            return
//        }
//        AF.request(url).responseString { response in
//            guard let html = response.result.
//
//        }
//
//
//
//            Alamofire.request(.GET, url!, parameters: nil)
//
//                .responseString { (request, response, data, error) in
//
//                    var content = ""
//                    let html = HTMLDocument(string: data)
//
//                    if let ogTags = html.nodesMatchingSelector("meta[property=\"og:description\"]") {
//                        for tag in ogTags {
//                            content = (tag.attributes?["content"] as? String)!
//                        }
//                    }
//
//                    var image = ""
//                    if let imgTags = html.nodesMatchingSelector("img") {
//                        for img in imgTags {
//                            if(img.attributes?["data-src"] != nil){
//                               image = (img.attributes?["data-src"] as? String)!
//                            }
//                        }
//                    }
//
//                   ret = [ "content": content , "image" : image ]
//                   completion(ret, error)
//            }
//        }
//
//    }
}

extension String {
    func removeString(string: String) -> String {
        let startIndex = string.index(string.startIndex, offsetBy: 24)
        let endIndex = string.index(string.endIndex, offsetBy: 4)
        return String(string[startIndex..<endIndex])
    }
}
