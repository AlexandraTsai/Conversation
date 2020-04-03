//
//  AlexCell.swift
//  Conversation
//
//  Created by 蔡佳宣 on 2020/3/28.
//  Copyright © 2020 蔡佳宣. All rights reserved.
//

import UIKit

protocol TagCellProtocol: class {
    func didTapCancelButtonInCell(_ cell: TagCell)
}

class TagCell: UICollectionViewCell {
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.init(hexString: "000000", alpha: 0.5)
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.init(hexString: "C2C9D6"), for: .normal)
        return button
    }()
    
    weak var delegate: TagCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        layer.cornerRadius = 5
        addSubview(nameLabel)
        addSubview(deleteButton)
        addSubview(coverImageView)

        coverImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 3).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupData(_ image: UIImage?, _ name: String) {
        if let image = image {
            coverImageView.image = image
        } else {
            coverImageView.image = nil
            coverImageView.backgroundColor = UIColor.gray
        }
        nameLabel.text = name
    }
    
    @objc func didTapCancelButton(sender: UIButton) {
        delegate?.didTapCancelButtonInCell(self)
    }
}
