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
            toTextView.inputAccessoryView = keyboardReturnView
        }
    }
    
    @IBOutlet weak var subjectTextView: UITextView! {
        didSet {
            subjectTextView.delegate = self
            subjectTextView.inputAccessoryView = keyboardReturnView
        }
    }
    
    @IBOutlet weak var toCollectionView: TagField! {
        didSet {
            toCollectionView.delegate = self
            toCollectionView.dataSource = self
            toCollectionView.registerCellWithNib(identifier: String(describing: TagCell.self), bundle: nil)
            toCollectionView.register(AlexCell.self, forCellWithReuseIdentifier: String(describing: AlexCell.self))
            toCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: "Cell"))
            
            //ContentInset
            let updnSpacing = (toCollectionView.bounds.height - tagCellHeight) / 2
            toCollectionView.contentInset = UIEdgeInsets(top: updnSpacing,
                                                         left: 20,
                                                         bottom: updnSpacing,
                                                         right: 20)
            //FlowLayout
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            toCollectionView.collectionViewLayout = layout
            
            //Tap Gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(collectionViewDidTap))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.delegate = self
            toCollectionView.addGestureRecognizer(tap)
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
    
    let keyboardReturnView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 62))
    
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.inputAccessoryView = keyboardReturnView
        textfield.delegate = self
        return textfield
    }()
    
    let tagCellHeight: CGFloat = 23
    
    let minimumLineSpacing: CGFloat = 10
    
    lazy var friendTagSecondRowHeight: CGFloat = {
        return tagCellHeight * 2 + minimumLineSpacing
    }()
    
    lazy var friendTagThirdRowHeight: CGFloat = {
        return tagCellHeight * 3 + minimumLineSpacing * 2
    }()
    
//    var endEditing: Bool = true
    
    let viewModel = ConversationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendListTableView()
        setupReturnView()
        friendListTableView.isHidden = true
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.friendList.bind { [weak self] friendList in
            DispatchQueue.main.async {
                self?.friendListTableView.reloadData()
                DispatchQueue.main.async {
                    self?.textfield.becomeFirstResponder()
                    self?.adjustCollectionViewHeight()
                }
            }
        }
        viewModel.selectedFriend.bind { [weak self] friendList in
            self?.textfield.text = ""
            self?.toCollectionView.reloadData()
            DispatchQueue.main.async {
                self?.textfield.becomeFirstResponder()
                self?.adjustCollectionViewHeight()
            }
        }
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
    
    private func adjustCollectionViewHeight() {
        let height = toCollectionView.contentSize.height
        switch height {
        case (tagCellHeight):
            toCollectionView.heightConstraint.constant = 52
        case friendTagSecondRowHeight, friendTagThirdRowHeight:
            toCollectionView.heightConstraint.constant = 52 + (height - tagCellHeight - minimumLineSpacing)
        default:
            break
        }
    }

    //MARK: - Keyboard
    private func setupReturnView() {
        keyboardReturnView.clipsToBounds = false
        keyboardReturnView.backgroundColor = .white
        let returnBtn = UIButton()
        returnBtn.setImage(UIImage(named: "close_arrow_btn"), for: .normal)
        keyboardReturnView.addSubview(returnBtn)
        returnBtn.translatesAutoresizingMaskIntoConstraints = false
        returnBtn.centerYAnchor.constraint(equalTo: keyboardReturnView.centerYAnchor).isActive = true
        returnBtn.centerXAnchor.constraint(equalTo: keyboardReturnView.centerXAnchor).isActive = true
        returnBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        returnBtn.heightAnchor.constraint(equalTo: returnBtn.widthAnchor).isActive = true
        returnBtn.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
    }
    
    private func checkTextfield() {
        if textfield.text == "" {
            textfield.resignFirstResponder()
            toCollectionView.heightConstraint.constant = 52
            if let layout = toCollectionView.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            return
        }
        guard let email = textfield.text else { return }
        if email.isValidEmail() {
            viewModel.insertInvitingFriendWith(email: email)
        } else {
            let alert = UIAlertController(title: "Not a valid email. Please try a valid email address",
                                          message: nil,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: { [weak self] in
                self?.textfield.text = nil
            })
        }
    }

    //MARK: - Tap Gesture Handler
    @objc func returnButtonTapped() {
        checkTextfield()
    }
    
    @objc func collectionViewDidTap() {
        textfield.becomeFirstResponder()
        if let layout = toCollectionView.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        toCollectionView.contentSize.width = toCollectionView.bounds.width - 40
        toCollectionView.layoutIfNeeded()
        adjustCollectionViewHeight()
        textfield.becomeFirstResponder()
    }
    
    @objc func didTapCancelFriendButton(sender: UIButton) {
        viewModel.deselectFriendAt(index: sender.tag)
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
        if viewModel.selectedFriend.value.count == 0 {
            toTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
            UIView.animate(withDuration: 0.5) {
                self.toTextView.placeHolderTopConstraint.constant = (self.toTextView.bounds.height - self.toTextView.placeholderLabel.bounds.height)/2
                self.view.layoutIfNeeded()
            }
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

extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        endEditing = false
        showFriendList()
        if viewModel.selectedFriend.value.count == 0 {
            toCollectionView.placeholderLabel.font = UIFont.systemFont(ofSize: 10)
            UIView.animate(withDuration: 0.5) {
                self.toCollectionView.placeHolderTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        friendListTableView.isHidden = true
        
        if viewModel.selectedFriend.value.count == 0 {
            toCollectionView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
            UIView.animate(withDuration: 0.5) {
                self.toCollectionView.placeHolderTopConstraint.constant = (self.toCollectionView.bounds.height - self.toCollectionView.placeholderLabel.bounds.height)/2
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        endEditing = true
        checkTextfield()
        return true
    }
}

extension ConversationViewController: UIGestureRecognizerDelegate { }

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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlexCell.self), for: indexPath)
        guard let tagCell = cell as? AlexCell else { return cell }
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
            let size: CGSize = name.size(withAttributes:  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
            return CGSize(width: size.width + (tagCellHeight + 3) * 2 , height: tagCellHeight)
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
        return viewModel.friendList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)
        guard let friendListCell = cell as? FriendListCell,
            indexPath.row < viewModel.friendList.value.count else { return cell }
        var friend = viewModel.friendList.value[indexPath.row]
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
        DispatchQueue.global().async {
            self.viewModel.removeFriendListAt(indexPath.row)
        }
    }
}
