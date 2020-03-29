//
//  UICollectionView+Extension.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/27.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

extension UICollectionView {
        
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
