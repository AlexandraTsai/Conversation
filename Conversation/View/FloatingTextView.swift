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
    
    required init?(coder: NSCoder) {
       super.init(coder: coder)
        self.textContainerInset = UIEdgeInsets(top: 14.5,
                                               left: 20,
                                               bottom: 14.5,
                                               right: 20)
    }
    
    @IBOutlet weak var countDownLabel: CountDownLabel! {
        didSet {
            countDownLabel.maxChar = 85
        }
    }
    
}
