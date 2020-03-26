//
//  UITableView+Extension.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/25.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: identifier)
    }
}
