//
//  OriginListTableViewCell.swift
//  uread
//
//  Created by Hao Dong on 28/09/2016.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import AlamofireImage

class OriginListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var originImage: UIImageView!
    @IBOutlet weak var originName: UILabel!
    @IBOutlet weak var originType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(origin: OriginInfo) {
        if origin.originType == "Jianshu" {
            originType.image = UIImage(named: "btn_info_source_jianshu")
        } else if origin.originType == "Wechat" {
            originType.image = UIImage(named: "btn_info_source_wechat")
        } else {
            originType.image = UIImage(named: "btn_info_source_zhihu")
        }
        originImage.af_setImageWithURL(NSURL(string: origin.originPortrait)!)
        originName.text! = origin.originName
    }

}
