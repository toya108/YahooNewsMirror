//
//  ArticleCell.swift
//  YahooNewsMirror
//
//  Created by TOUYA KAWANO on 2019/11/16.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var pubDateLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                
    }
    
}
