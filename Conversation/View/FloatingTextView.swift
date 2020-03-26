//
//  FloatingTextView.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/26.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class FloatingTextView: UITextView {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var placeHolderTopConstraint: NSLayoutConstraint!
    
    var floatingLabel: UILabel = UILabel()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
        
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
}



