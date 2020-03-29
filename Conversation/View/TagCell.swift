//
//  TagCell.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/27.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(image: UIImage?, name: String) {
        if let photo = image {
            coverImageView.image = photo
        }
        nameLabel.text = name
    }
}
