//
//  ConversationViewController.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/24.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var toTextView: FloatingTextView! {
        didSet {
            toTextView.delegate = self
            toTextView.inputAccessoryView = returnView
        }
    }
    
    @IBOutlet weak var subjectTextView: UITextView! {
        didSet {
            subjectTextView.delegate = self
            subjectTextView.inputAccessoryView = returnView
        }
    }
        
    var friendListTableView = UITableView() {
        didSet {
            self.friendListTableView.delegate = self
            self.friendListTableView.dataSource = self
            self.friendListTableView.registerCellWithNib(identifier: String(describing: FriendListCell.self),
                                                          bundle: nil)
            self.friendListTableView.separatorStyle = .none
        }
    }
    
    let returnView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 62))
    
    let viewModel = ConversationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendListTableView()
        setupReturnView()
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
    
    private func showFriendList() {
        friendListTableView.isHidden = false
        friendListTableView.reloadData()
    }

    //MARK: - Keyboard
    private func setupReturnView() {
        returnView.backgroundColor = .white
        let returnBtn = UIButton()
        returnView.addSubview(returnBtn)
        returnBtn.translatesAutoresizingMaskIntoConstraints = false
        returnBtn.centerYAnchor.constraint(equalTo: returnView.centerYAnchor).isActive = true
        returnBtn.centerXAnchor.constraint(equalTo: returnView.centerXAnchor).isActive = true
        returnBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        returnBtn.backgroundColor = UIColor.red
//        returnBtn.addTarget(self, action: returnButtonTapped(), for: .touchUpInside)
    }
    
    @objc func returnButtonTapped() {
        resignFirstResponder()
    }
}

//MARK: - TextView Delegate
extension ConversationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showFriendList()
        toTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 10)
        UIView.animate(withDuration: 0.5) {
            self.toTextView.placeHolderTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        friendListTableView.isHidden = true
        toTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        UIView.animate(withDuration: 0.5) {
            self.toTextView.placeHolderTopConstraint.constant = (self.toTextView.bounds.height - self.toTextView.placeholderLabel.bounds.height)/2
            self.view.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ///Dismiss the keyboard on return key
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
