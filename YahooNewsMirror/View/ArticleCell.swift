//
//  ArticleCell.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/16.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit

/// 記事表示用のセル
class ArticleCell: UITableViewCell {
    
    /// サムネイル画像
    @IBOutlet weak var articleImage: UIImageView!
    /// タイトル
    @IBOutlet weak var titleLable: UILabel!
    /// 日付
    @IBOutlet weak var pubDateLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                
    }
    
}
