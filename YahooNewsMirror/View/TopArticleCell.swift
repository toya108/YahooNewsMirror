//
//  TopArticleCell.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/21.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit

/// トップの記事表示用のセル
class TopArticleCell: UITableViewCell {
    
    /// 日付
    @IBOutlet weak var pubDateLabel: UILabel!
    /// タイトル
    @IBOutlet weak var titleLable: UILabel!
    /// 記事画像
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
