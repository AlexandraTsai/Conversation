//
//  ConversationViewController+Delegate.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/4/3.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

//MARK: - TextView Delegate
extension ConversationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case is FloatingTextView:
            changeEditingStyleFor(view: subjectTextView, isEditing: true)
            subjectTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 10)
            UIView.animate(withDuration: 0.5) {
                self.subjectTextView.placeHolderTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        default:
            changeEditingStyleFor(view: messageView, isEditing: true)
            activeView = messageView
            messageView.placeholderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeView = nil
        
        switch textView {
        case is FloatingTextView:
            changeEditingStyleFor(view: subjectTextView, isEditing: false)
            if textView.text == "" {
                subjectTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
                UIView.animate(withDuration: 0.5) {
                    self.subjectTextView.placeHolderTopConstraint.constant = (self.subjectTextView.bounds.height - self.subjectTextView.placeholderLabel.bounds.height)/2
                    self.view.layoutIfNeeded()
                }
            }
        default:
            changeEditingStyleFor(view: messageView, isEditing: false)
            if messageView.textView.text == "" {
                messageView.placeholderLabel.isHidden = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ///Dismiss the keyboard on return key
        if text == "\n" && textView is FloatingTextView {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        checkSendable()
        switch textView {
        case is FloatingTextView:
            subjectTextView.countDownLabel.currentChar = textView.text.count

            let sizeToFitIn = CGSize(width: subjectTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = subjectTextView.sizeThatFits(sizeToFitIn)
            let originHeight = 52 - subjectTextView.textContainerInset.top - subjectTextView.textContainerInset.bottom
            let threeLinesHeight = 52 + originHeight * 2
            if newSize.height > threeLinesHeight {
                return
            }
            textViewHeight.constant =  newSize.height
        default:
            messageView.countDownLabel.currentChar = textView.text.count
        }
    }
    
}

//MARK: - TextField Delegate
extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showFriendList()
        changeEditingStyleFor(view: toCollectionView, isEditing: true)
        if viewModel.selectedFriend.value.count == 0 {
            toCollectionView.placeholderLabel.font = UIFont.systemFont(ofSize: 10)
            UIView.animate(withDuration: 0.5) {
                self.toCollectionView.placeHolderTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        viewModel.filterFriendWith(text)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        friendListTableView.isHidden = true
        changeEditingStyleFor(view: toCollectionView, isEditing: false)
        
        if viewModel.selectedFriend.value.count == 0 {
            toCollectionView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
            UIView.animate(withDuration: 0.5) {
                self.toCollectionView.placeHolderTopConstraint.constant = (self.toCollectionView.bounds.height - self.toCollectionView.placeholderLabel.bounds.height)/2
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkTextfieldBeforeReturn()
        return true
    }
}

//MARK: - Gesture Recognizer Delegate
extension ConversationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var view = touch.view
        while view != nil {
            if view is UITableView {
                return false
            } else {
                view = view?.superview
            }
        }
        return true
    }
}

//MARK: - CollectionView Delegate & DataSource
extension ConversationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedFriend.value.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //The last cell
        if isTextfieldCell(collectionView, at: indexPath) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            textfield.frame = cell.bounds
            cell.addSubview(textfield)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCell.self), for: indexPath)
        guard let tagCell = cell as? TagCell else { return cell }
        var friend = viewModel.selectedFriend.value[indexPath.row]
        tagCell.setupData(friend.image, friend.tagName)
        tagCell.deleteButton.addTarget(self, action: #selector(didTapCancelFriendButton), for: .touchUpInside)
        tagCell.deleteButton.tag = indexPath.row
        return tagCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isTextfieldCell(collectionView, at: indexPath) {
            return CGSize(width: 100, height: tagCellHeight)
        } else {
            let name = NSString(string: viewModel.selectedFriend.value[indexPath.row].tagName)
            let size: CGSize = name.size(withAttributes:  [.font: UIFont.systemFont(ofSize: 13.0)])
            return CGSize(width: size.width + (tagCellHeight + 5) * 2 , height: tagCellHeight)
        }
    }

    func isTextfieldCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> Bool {
        return (indexPath.row == (collectionView.numberOfItems(inSection: 0) - 1))
    }
    
}

//MARK: - CollectionViewDelegateFlowLayout
extension ConversationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
}


//MARK: - TableView Delegate & DataSource
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.showingFriendList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)
        guard let friendListCell = cell as? FriendListCell,
            indexPath.row < viewModel.showingFriendList.value.count else { return cell }
        var friend = viewModel.showingFriendList.value[indexPath.row]
        friendListCell.setupWith(image: friend.image,
                                 name: friend.showName,
                                 email: friend.email)
        return friendListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * UIScreen.main.bounds.width / 375
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectFriendFromList(atIndex: indexPath.row)
    }
}

extension ConversationViewController: MessageViewDelegate {
    
    func expandTextView(_ messageView: MessageView) {
        switch messageView.isExpanded {
        case true:
            if messageView.textView.isFirstResponder {
                let originHeight = messageView.originBottomConstraint - messageView.originTopConstraint
                let totalHeight = messageView.expandedTopConstraint - messageView.frame.maxY
                messageViewTopConstraint.constant = (messageView.expandedTopConstraint + (totalHeight - originHeight))
            } else {
                messageViewTopConstraint.constant = messageView.originTopConstraint
            }
        case false:
            messageViewTopConstraint.constant = messageView.expandedTopConstraint
        }
    }
    
    func sendMessage(_ messageView: MessageView) {
        if viewModel.selectedFriend.value.count == 0 {
            showAlertWith(title: "Please add participants to the chat.",
                          completion: nil)
        }
        if subjectTextView.text == "" {
            showAlertWith(title: "Please set a subject", completion: nil)
        }
        if messageView.textView.text == "" {
            showAlertWith(title: "Please add a message to this conversation",
                          completion: nil)
        }
    }
}
