//
//  SectionHeaderView.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/14/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import SnapKit

// Header view for each section in collection view in PersonalNewsViewController.
class SectionHeaderView: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 26)
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
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
}
