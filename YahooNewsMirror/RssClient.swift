//
//  RssClient.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/17.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    // 不正なURLが指定されました。
    case invalidURL
    // 不正なレスポンスが返されました。
    case invalidResponse
    // 想定外のエラーです。
    case unknown
}

/// RSS取得用クラス
class RssClient {
    
    /// 記事の一覧を取得します。
    /// - Parameter urlString: 取得元RSSのurl
    /// - Parameter completion: 完了時の処理
    static func fetchItems(urlString: String, completion: @escaping (Result<[Item], Error>) -> ()) {
         // URL型に変換できない文字列を弾く
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
}
