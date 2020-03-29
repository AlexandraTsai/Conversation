//
//  AlexCell.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/28.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

class AlexCell: UICollectionViewCell {
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        print("=========setupViews========")
        addSubview(nameLabel)
        addSubview(deleteButton)
//        coverImageView.frame = CGRect(x: 0, y: 0, width: Int(self.bounds.height), height: Int(self.bounds.height))
        addSubview(coverImageView)

        coverImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupData(_ image: UIImage?, _ name: String) {
        print("///////// set image - coverImageView \(coverImageView.frame) //////")
        if let image = image {
            coverImageView.image = image
        }
        nameLabel.text = name
        //測試用
        nameLabel.backgroundColor = UIColor.blue
        deleteButton.backgroundColor = UIColor.yellow
    }
}
