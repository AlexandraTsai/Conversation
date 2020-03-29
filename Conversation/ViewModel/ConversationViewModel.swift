//
//  ConversationViewModel.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/24.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewModel {
    
    var friendList: Bindable<[Friend]> = Bindable<[Friend]>([Friend]()) {
        didSet {
            print(friendList.value)
        }
    }
    
    init() {
        self.fetchFriends()
    }
    
    private func fetchFriends() {
        friendList.value = dummyFriendList
    }
    
    func removeFriendListAt(_ index: Int) {
        guard index < friendList.value.count else {
            return
        }
        var originList = friendList.value
        originList.remove(at: index)
        friendList.value = originList
    }
}

let dummyFriendList: Array<Friend> = [
    Friend(firstName: "Janet", lastName: "CHIU", email: "jordanLin@gmail.com", image: UIImage(named: "fimage1")),
    Friend(firstName: "Wendy", lastName: "CHOU", email: "jordanLin@gmail.com", image: UIImage(named: "fimage2")),
    Friend(firstName: "Marria", lastName: "Co", email: "jordanLin@gmail.com", image: nil),
    Friend(firstName: "Kelia", lastName: "Moniz", email: "jordanLin@gmail.com", image: UIImage(named: "fimage3")),
    Friend(firstName: "Anita", lastName: "Chen", email: "jordanLin@gmail.com", image: UIImage(named: "fimage4")),
    Friend(firstName: "Cindy", lastName: "Chang", email: "jordanLin@gmail.com", image: UIImage(named: "fimage5")),
    Friend(firstName: "Jordan", lastName: "Lin", email: "jordanLin@gmail.com", image: UIImage(named: "mimage1")),
    Friend(firstName: "David", lastName: "Wang", email: "jordanLin@gmail.com", image: nil),
    Friend(firstName: "Fabio", lastName: "Wu", email: "jordanLin@gmail.com", image: UIImage(named: "mimage2"))
]
