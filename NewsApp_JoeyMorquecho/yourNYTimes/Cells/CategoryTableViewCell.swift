//
//  CategoryTableViewCell.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// CategoryTableViewCell displayed in table view of category names.
class CategoryTableViewCell: UITableViewCell {
    
    var categoryLabel = UILabel()
    var button = UIButton()
    
    var isCategoryAdded: Bool = false
    var category:String = ""
    
    var checkImage = UIImage(systemName: "checkmark.circle.fill")
    var plusImage = UIImage(systemName: "plus.circle.fill")
    let orangeTintColor = UIColor(red: 255/255, green: 140/255, blue: 40/255, alpha: 1)
    
    var savedCategories:[String] = []
    let userDefaults = UserDefaults.standard

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        
        button.setImage(plusImage, for: .normal)
        isCategoryAdded = false
        
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        contentView.addSubview(button)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates cell button image based on saved categories.
    func updateCell() {
        getSavedCategories()
        
        if savedCategories.contains(category) {  // If category is in saved categories.
            button.setImage(checkImage, for: .normal)
            button.tintColor = orangeTintColor
            isCategoryAdded = true
        } else {  // If category is not saved.
            button.setImage(plusImage, for: .normal)
            button.tintColor = .lightGray
            isCategoryAdded = false
        }
    }
    
    /// Gets saved categories from UserDefaults and assigns it to savedCategories array.
    func getSavedCategories(){
        if let array = userDefaults.value(forKey: Constants.UserDefaults.categories) as? [String] {
            self.savedCategories = array
        }
    }
    
    /// Toggles button image and saves categories in UserDefaults.
    @objc func buttonClicked() {
        getSavedCategories()  // Gets saved categories.
        
        if isCategoryAdded {  // Category is being deleted from home page.
            isCategoryAdded = false
            button.setImage(plusImage, for: .normal)
            button.tintColor = .lightGray
            
            // Deletes this cell's category from saved categories.
            savedCategories = savedCategories.filter({ (str) -> Bool in
                str != category
            })
        } else {  // Category is being added to home page.
            isCategoryAdded = true
            button.setImage(checkImage, for: .normal)
            button.tintColor = orangeTintColor
            
            // This cell's category being added to saved categories.
            savedCategories.append(category)
        }
        
        userDefaults.set(savedCategories, forKey: Constants.UserDefaults.categories)
    }
    
    func setUpConstraints() {
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
        }
        
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
}
