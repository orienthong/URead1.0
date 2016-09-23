//
//  customCollectionViewCell.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit

class customCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configureCell(withImage image: UIImage, userName: String, messageText: String, dateText: String) {
        chatImageView.image = image
        nameText.text! = userName
        timeLabel.text! = dateText
        detailLabel.text! = messageText
    }
    
//    override var selected: Bool {
//        if selected {
//            self.backgroundColor = UIColor(red: 108/255.0, green:105.0/255.0, blue:164.0/255.0, alpha:1.0)
//        } else {
//            self.backgroundColor = UIColor(red:102/255.0, green:99.0/255.0, blue:157.0/255.0, alpha:1.0)
//        }
//    }
    
}
