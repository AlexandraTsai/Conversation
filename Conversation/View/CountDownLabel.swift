//
//  CountDownLabel.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/4/2.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class CountDownLabel: UILabel {

    var maxChar: Int? {
        didSet {
            countdownCheck()
        }
    }
    
    var currentChar: Int = 0 {
        didSet {
            countdownCheck()
        }
    }
    
    let normalColor = UIColor(hexString: "7C8494")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        textColor = normalColor
    }
    
    func countdownCheck() {
        guard let maxChar = maxChar else { return }
        text = String(currentChar) + "/" + String(maxChar)
        if currentChar > maxChar || (maxChar - currentChar < 10) {
            textColor = .red
        } else {
            textColor = normalColor
        }
    }
}
