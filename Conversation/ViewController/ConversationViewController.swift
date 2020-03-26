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
        
    var friendListTableView = UITableView() {
        didSet {
            self.friendListTableView.delegate = self
            self.friendListTableView.dataSource = self
            self.friendListTableView.registerCellWithNib(identifier: String(describing: FriendListCell.self),
                                                          bundle: nil)
        }
    }
    
    let viewModel = ConversationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendListTableView()
        friendListTableView.isHidden = true
    }
    
    //MARK: - Friend List Table View
    private func setupFriendListTableView() {
        friendListTableView = UITableView()
        view.addSubview(friendListTableView)
        friendListTableView.translatesAutoresizingMaskIntoConstraints = false
        friendListTableView.topAnchor.constraint(equalTo: toTextView.bottomAnchor, constant: 10).isActive = true
        friendListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        friendListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        friendListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func showFriendList() {
        friendListTableView.isHidden = false
        friendListTableView.reloadData()
    }

}

extension ConversationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showFriendList()
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)
        guard let friendListCell = cell as? FriendListCell else { return cell }
        var friend = viewModel.friendList[indexPath.row]
        friendListCell.setupWith(image: friend.image,
                                 name: friend.showName,
                                 email: friend.email)
        return friendListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * UIScreen.main.bounds.width / 375
    }
    
}
