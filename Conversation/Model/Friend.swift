//
//  Friend.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/24.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import Foundation
import UIKit

struct Friend {
    let firstName: String
    let lastName: String
    lazy var showName: String = self.firstName + " " + self.lastName
    let email: String
    let image: UIImage?
}
