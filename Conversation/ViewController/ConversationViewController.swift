//
//  ConversationViewController.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/24.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var toTextView: UITextView! {
        didSet {
            toTextView.delegate = self
        }
    }
    
    @IBOutlet weak var subjectTextView: UITextView! {
        didSet {
            subjectTextView.delegate = self
        }
    }
    
    var friendListTableView: UITableView? {
        didSet {
            self.friendListTableView?.delegate = self
        }
    }
    
    let viewModel = ConversationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showFriendList() {
        
    }

}

extension ConversationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
