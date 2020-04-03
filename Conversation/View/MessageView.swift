//
//  MessageTextView.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/4/2.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: class {
    
    func expandTextView(_ messageView: MessageView)
    
    func sendMessage(_ messageView: MessageView)
}

enum SendButtonColor {
    case sendable
    case unsendable
    
    var color: UIColor {
        switch self {
        case .sendable:
            return UIColor(hexString: "179DD7")
        default:
            return UIColor(hexString: "E5E8EE")
        }
    }
}

class MessageView: UIView {
    
    @IBOutlet weak var textView: UITextView!
        
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
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            sendButton.tintColor = SendButtonColor.unsendable.color
        }
    }
    
    weak var delegate: MessageViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @IBAction func expandBtnTapped(_ sender: Any) {
        delegate?.expandTextView(self)
        isExpanded = !isExpanded
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        delegate?.sendMessage(self)
    }
    
    var originTopConstraint: CGFloat = 0
    
    var originBottomConstraint: CGFloat = 0
    
    var expandedTopConstraint: CGFloat = 0

    var isExpanded: Bool = false
    
    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 10
        drawShadow()
    }
    
    func drawShadow() {
        addShadow(shadowColor: UIColor.lightGray.cgColor,
        offset: .zero,
        shadowRadius: 3,
        opacity: 1)
    }
    
    func setConstraint(originTop topConstraint:CGFloat, originbottom bottomConstraint: CGFloat, expandedTop expandedTopConstraint: CGFloat) {
        originTopConstraint = topConstraint
        originBottomConstraint = bottomConstraint
        self.expandedTopConstraint = expandedTopConstraint
    }
    
    func changeSendButtonStatusTo(isSendable: Bool) {
        if isSendable {
            sendButton.tintColor = SendButtonColor.sendable.color
        } else {
            sendButton.tintColor = SendButtonColor.unsendable.color
        }
    }
}
