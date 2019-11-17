//
//  ParentViewController.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/17.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ParentViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Second")
        let childViewControllers: [UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
