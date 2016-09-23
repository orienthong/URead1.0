//
//  ArticleTableViewCell.swift
//  URead1.0
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import UIKit

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleWarpper: UIImageView!
    
    @IBOutlet weak var articleCoverImage: UIImageView!
    
    @IBOutlet weak var articleTitleWarpper: UIView!
    
    @IBOutlet weak var artcleCoverImageMask: UIImageView!
    
    @IBOutlet weak var articleDescription: UILabel!
    
    @IBOutlet weak var originImage: UIImageView!
    
    @IBOutlet weak var articleAuthor: UILabel!
    
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artcleCoverImageMask.alpha = 0.93
        
        originImage.layer.masksToBounds = true
        originImage.layer.cornerRadius = originImage.bounds.size.width * 0.5
        
        articleTitle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        articleTitle.numberOfLines = 2
        
        articleDescription.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        articleDescription.numberOfLines = 2
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        if selected {
            articleWarpper.layer.shadowColor = UIColor.clearColor().CGColor
        }else{
            articleWarpper.layer.shadowColor = UIColor(colorLiteralRed: 190/255, green: 245/255, blue: 170/255, alpha: 1.0).CGColor
            articleWarpper.layer.shadowOpacity = 0.5
            articleWarpper.layer.shadowRadius = 2.5
            articleWarpper.layer.shadowOffset = CGSize(width: 3.5, height: 3.5)
        }
        
    }
    
    // 自定义按下效果
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            articleWarpper.layer.shadowColor = UIColor.clearColor().CGColor
        }
    }
    
}