//
//  RssClient.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/17.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation
import HTMLReader

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
    
    /// 記事の画像のurlを取得します
    /// - サムネイル表示のために用意
    /// - Warning: URLから取得先のHTML全部取ってきてサムネだけ抜き出した上で画像のURL返してるから非常に冗長。
    ///            かつロードにも時間がかかるのでキャッシュに持たせるとかして修正を検討してください。
    ///
    /// - Parameter urlStr: 画像取得先のurl
    /// - Parameter completion: 完了後の処理
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
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            completion(.success(imageUrl))
        }
        catch {
            completion(.failure(error))
        }
    }
}

/// ネットワークエラー
enum NetworkError: Error {
    // 不正なURLが指定されました。
    case invalidURL
    // 不正なレスポンスが返されました。
    case invalidResponse
    // 想定外のエラーです。
    case unknown
}
/// アプリケーションエラー
enum AppalicationError: Error {
    // 何かのパースに失敗しました。
    case parseFailed
    // 想定外のエラーです。
    case unknown
}
