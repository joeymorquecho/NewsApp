//
//  ArticleTableViewCell.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/5/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// ArticleTableViewCell in tableview of SearchViewController.
class ArticleTableViewCell: UITableViewCell {
    
    var articleNameTextView = UITextView()
    var articleImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        articleNameTextView.sizeToFit()
        articleNameTextView.font = UIFont.boldSystemFont(ofSize: 18)
        articleNameTextView.isUserInteractionEnabled = false // Allows for textView to be selected for didSelectRowAt.
        articleNameTextView.translatesAutoresizingMaskIntoConstraints = false
        articleNameTextView.isEditable = false
        articleNameTextView.isScrollEnabled = false
        articleNameTextView.isSelectable = false
        contentView.addSubview(articleNameTextView)
        
        articleImageView.backgroundColor = .lightGray
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.layer.masksToBounds = true
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleImageView)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Assigns headline text and image in cell.
    func configure(headline: String, imageUrl: String) {
        
        self.articleNameTextView.text = headline
        
        if imageUrl != "" {
            NetworkManager.getArticleImage(fromPartialUrl: imageUrl) { (image) in
                self.articleImageView.image = image
            }
        }
    }
    
    func setUpConstraints() {
        articleNameTextView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-150)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        articleImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(articleNameTextView.snp.trailing).offset(30)
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }
}
