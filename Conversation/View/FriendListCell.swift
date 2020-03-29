//
//  FriendListCell.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/25.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var coverLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(image: UIImage?, name: String, email: String) {
        if let photo = image {
            coverImageView.image = photo
        } else if let representChar = name.first {
            coverImageView.backgroundColor = UIColor.gray
            coverImageView.image = nil
            coverLabel.text = String(representChar)
        }
        coverLabel.isHidden = (image != nil)
        nameLabel.text = name
        emailLabel.text = email
    }
}
