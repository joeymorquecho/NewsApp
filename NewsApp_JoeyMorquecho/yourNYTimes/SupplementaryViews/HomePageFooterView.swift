//
//  HomePageFooterView.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/15/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// HomePageFooterView is the footer view in the collection view in PersonalNewsViewController.
class HomePageFooterView: UICollectionReusableView {
        
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.text = "Add your favorite topics in Categories Tab"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
