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

    let wkWebView = WKWebView()
    var urlStr: String?
    
    init(urlStr: String) {
        self.urlStr = urlStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
