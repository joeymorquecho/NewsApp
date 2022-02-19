//
//  ArticleCollectionViewCell.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// ArticleCollectionViewCell displayed when a category is chosen.
class ArticleCollectionViewCell: UICollectionViewCell {
    
    var articleImageView: UIImageView!
    var headlineTextView: UITextView!
    
    var imageUrl:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        articleImageView = UIImageView()
        articleImageView.backgroundColor = .lightGray
        articleImageView.contentMode = .scaleAspectFill
        
        articleImageView.layer.masksToBounds = true
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleImageView)
        
        headlineTextView = UITextView()
        headlineTextView.font = UIFont.boldSystemFont(ofSize: 18)
        
        headlineTextView.isUserInteractionEnabled = false // Allows for textView to be selected for didSelectItemAt.
        headlineTextView.isEditable = false
        headlineTextView.isSelectable = false
        headlineTextView.isScrollEnabled = false
        headlineTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headlineTextView)
                
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds image to cell from url string.
    func addImage(url: String) {
        NetworkManager.getArticleImage(fromFullUrl: url) { (image) in
            self.articleImageView.image = image
        }
    }
    
    /// Opens Article webpage from url string.
    func openUrl(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func setUpConstraints() {
        articleImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-contentView.frame.width * (3.0/4))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        headlineTextView.snp.makeConstraints { (make) in
            make.top.equalTo(articleImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
