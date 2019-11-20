//
//  DetailViewController.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/18.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import WebKit

class DetailWebViewController: UIViewController {
    
    // MARK: Properties

    /// web表示用View
    private let wkWebView = WKWebView()
    /// 読み込むURL
    private var urlStr: String?
    
    // MARK: Initializer

    init(urlStr: String) {
        self.urlStr = urlStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: WebView適当すぎるのでプログレスバーとか戻るボタンとか付けたい
        wkWebView.frame = view.frame
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.allowsBackForwardNavigationGestures = true
        let url = URLRequest(url: URL(string: urlStr!)!)
        wkWebView.load(url)
        view.addSubview(wkWebView)
    }
}

extension DetailWebViewController: WKNavigationDelegate {
    
}

extension DetailWebViewController: WKUIDelegate {
    
}
