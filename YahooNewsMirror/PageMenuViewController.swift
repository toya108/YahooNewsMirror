//
//  PageMenuViewController.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/17.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageMenuViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return createNewsViewController()
    }
    
    private func createNewsViewController() -> [UIViewController] {
        var childViewControllers: [UIViewController] = []

        NewsType.AllCases().forEach {
            let vc = NewsViewController(newsType: $0)
            childViewControllers.append(vc)
        }
        return childViewControllers
    }
}
