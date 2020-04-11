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
    
    //The friend List show on tableView (all unselected friends/filtered friends)
    var showingFriendList: Bindable<[Friend]> = Bindable<[Friend]>([Friend]()) 
    
    var selectedFriend: Bindable<[Friend]> = Bindable<[Friend]>([Friend]())
    
    var unselectedFriend: [Friend] = [Friend]()
        
    init() {
        self.fetchFriends()
    }
    
    private func fetchFriends() {
        showingFriendList.value = dummyFriendList
        unselectedFriend = dummyFriendList
    }
    
    //MARK: - FriendList edit
    func removeFriendListAt(_ index: Int) {
        guard index < showingFriendList.value.count else {
            return
        }
        var originList = showingFriendList.value
        originList.remove(at: index)
        showingFriendList.value = originList
    }
    
    func addBackFriend(_ friend: Friend) {
        var originList = showingFriendList.value
        originList.append(friend)
        unselectedFriend.append(friend)
        showingFriendList.value = originList
    }
    
    //MARK: - Selected Friend edit
    func deselectFriendAt(index: Int) {
        var friendToBeRemove = selectedFriend.value[index]
        var selectedFriends = selectedFriend.value
        selectedFriends.remove(at: index)
        selectedFriend.value = selectedFriends
        if friendToBeRemove.tagName != friendToBeRemove.email {
            addBackFriend(friendToBeRemove)
        }
    }
    
    func selectFriendFromList(atIndex index: Int) {
        let friend = showingFriendList.value[index]
        removeFriendListAt(index)
        if let index = unselectedFriend.firstIndex(where: { $0 == friend}) {
            unselectedFriend.remove(at: index)
        }
        var selectedFriends = selectedFriend.value
        selectedFriends.append(friend)
        selectedFriend.value = selectedFriends
    }
    
    func insertInvitingFriendWith(email: String) {
        let friend = Friend(firstName: email,
                            lastName: email,
                            showName: email,
                            tagName: email,
                            email: email,
                            image: UIImage(named: "inviting"))
        var selectedFriends = selectedFriend.value
        selectedFriends.append(friend)
        selectedFriend.value = selectedFriends
    }
    
    func filterFriendWith(_ text: String) {
        var filteredFriends = [Friend]()
        for index in 0..<unselectedFriend.count {
            if unselectedFriend[index].showName.hasPrefix(text) {
                filteredFriends.append(unselectedFriend[index])
            }
        }
        showingFriendList.value = filteredFriends
    }
}

let dummyFriendList: Array<Friend> = [
    Friend(firstName: "Janet", lastName: "CHIU", email: "Janet@gmail.com", image: UIImage(named: "fimage1")),
    Friend(firstName: "Wendy", lastName: "CHOU", email: "WendyCHOU@gmail.com", image: UIImage(named: "fimage2")),
    Friend(firstName: "Marria", lastName: "Co", email: "Marria@gmail.com", image: nil),
    Friend(firstName: "Kelia", lastName: "Moniz", email: "KeliaMoniz@gmail.com", image: UIImage(named: "fimage3")),
    Friend(firstName: "Anita", lastName: "Chen", email: "Anita@gmail.com", image: UIImage(named: "fimage4")),
    Friend(firstName: "Cindy", lastName: "Chang", email: "Cindy@gmail.com", image: UIImage(named: "fimage5")),
    Friend(firstName: "Joe", lastName: "Lin", email: "JoeLin@gmail.com", image: UIImage(named: "mimage1")),
    Friend(firstName: "David", lastName: "Wang", email: "David@gmail.com", image: nil),
    Friend(firstName: "Fabio", lastName: "Wu", email: "Fabio@gmail.com", image: UIImage(named: "mimage2"))
]
