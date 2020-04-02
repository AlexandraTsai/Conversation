//
//  MessageTextView.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/4/2.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class MessageTextView: UITextView {
        
    @IBOutlet weak var countDownLabel: CountDownLabel! {
        didSet {
            countDownLabel.maxChar = 5000
        }
    }
    
    @IBOutlet weak var placeholderLabel: UILabel! {
        didSet {
            placeholderLabel.text = "Write your message..."
            placeholderLabel.textColor = UIColor.init(hexString: "000000",
                                                      alpha: 0.25)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @IBAction func expandBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
    }
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 10
        addShadow(shadowColor: UIColor.lightGray.cgColor,
                  offset: .zero,
                  shadowRadius: 3,
                  opacity: 1)
        textContainerInset = UIEdgeInsets(top: 14.5,
                                          left: 25,
                                          bottom: 14.5,
                                          right: 25)
    }

}
