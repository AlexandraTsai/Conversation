//
//  ConversationViewController.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/24.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var toCollectionView: TagField! {
        didSet {
            toCollectionView.layer.cornerRadius = 5
            toCollectionView.delegate = self
            toCollectionView.dataSource = self
        }
    }
        
    @IBOutlet weak var subjectTextView: FloatingTextView! {
         didSet {
             subjectTextView.layer.cornerRadius = 5
             subjectTextView.delegate = self
         }
     }
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var messageView: MessageView! {
        didSet {
            messageView.delegate = self
        }
    }
        
    @IBOutlet weak var messageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var friendListTableView: UITableView! {
        didSet {
            friendListTableView.delegate = self
            friendListTableView.dataSource = self
            friendListTableView.registerCellWithNib(identifier: String(describing: FriendListCell.self),
                                                          bundle: nil)
            friendListTableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var friendTableViewBottomConstraint: NSLayoutConstraint!

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
    
    var friendTableViewBottom: NSLayoutConstraint = NSLayoutConstraint()
    
    var activeView: UIView? = nil
                    
    let viewModel = ConversationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.textView.delegate = self
        setupReturnView()
        setupCollectionView()
        friendListTableView.isHidden = true
        bindViewModel()
        hideKeyboardWhenTappedAround()
        messageView.setConstraint(originTop: messageViewTopConstraint.constant,
                                  originbottom: messageViewBottomConstraint.constant,
                                  expandedTop: toCollectionView.frame.minY)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.drawShadow()
    }
    
    //MARK: - ViewModel binding
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
            self?.checkSendable()
            self?.textfield.text = ""
            self?.toCollectionView.reloadData()
            DispatchQueue.main.async {
                self?.textfield.becomeFirstResponder()
                self?.adjustCollectionViewHeight()
            }
        }
    }
    
    func showFriendList() {
        friendListTableView.isHidden = false
        friendListTableView.reloadData()
    }
    
    private func setupCollectionView() {
        toCollectionView.register(TagCell.self, forCellWithReuseIdentifier: String(describing: TagCell.self))
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
        keyboardReturnView.addShadow(shadowColor: UIColor.lightGray.cgColor,
                                     offset: .zero,
                                     shadowRadius: 3,
                                     opacity: 1)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if messageView.textView.isFirstResponder {
            switch messageView.isExpanded {
            case false:
                messageViewTopConstraint.constant = messageView.originTopConstraint - keyboardSize.height
            default: break
            }
            messageViewBottomConstraint.constant = messageView.originBottomConstraint + keyboardSize.height
        }
        //Editing toCollectionView
        if !friendListTableView.isHidden {
            friendTableViewBottomConstraint.constant = keyboardSize.height - 10
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        switch messageView.isExpanded {
        case false:
            messageViewTopConstraint.constant = messageView.originTopConstraint
        default: break
        }
        messageViewBottomConstraint.constant = messageView.originBottomConstraint
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func dismissKeyboard() {
        if subjectTextView.isFirstResponder || messageView.textView.isFirstResponder {
            view.endEditing(true)
        }
    }
    
    //MARK: - Check Before Action
    func checkTextfieldBeforeReturn() {
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
            showAlertWith(title: "Not a valid email. Please try a valid email address",
                          completion: { [weak self] in
                          self?.textfield.text = nil
            })
        }
    }
    
    func checkSendable() {
        if viewModel.selectedFriend.value.count != 0 && subjectTextView.text != "" && messageView.textView.text != "" {
            messageView.changeSendButtonStatusTo(isSendable: true)
        } else {
            messageView.changeSendButtonStatusTo(isSendable: false)
        }
    }
    
    //MARK: - Alert
    func showAlertWith(title: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }

    //MARK: - Tap Gesture Handler
    @objc func returnButtonTapped() {
        checkTextfieldBeforeReturn()
    }
    
    @objc func collectionViewDidTap() {
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
    
    //MARK: - Style
    func changeEditingStyleFor(view: UIView, isEditing: Bool) {
        switch isEditing {
        case true:
            view.layer.borderColor = UIColor(hexString: "1895EB").cgColor
            view.layer.borderWidth = 1
        default:
            view.layer.borderWidth = 0
        }
    }
}
