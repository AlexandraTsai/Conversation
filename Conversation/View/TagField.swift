//
//  TagCollectionView.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/27.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class TagField: UICollectionView {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var placeHolderTopConstraint: NSLayoutConstraint!
    
    var floatingLabel: UILabel = UILabel()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
