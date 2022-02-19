//
//  CategoriesViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// CategoriesViewController contains the table view of categories.
class CategoriesViewController: UIViewController {

    var categoriesTable: UITableView!
    
    let cellHeight: CGFloat = 60
    let categoriesCellReuseIdentifier = "categoriesCellReuseIdentifier"
    
    let categories = ["arts", "automobiles", "books", "business", "fashion", "food", "health", "home", "insider", "magazine", "movies", "nyregion", "obituaries", "opinion", "politics", "realestate", "science", "sports", "sundayreview", "technology", "theater", "t-magazine", "travel", "upshot", "us", "world"]
    
    var savedCategories:[String] = []  // Array of saved categories retrieved from UserDefaults.
    
    // UserDefaults initialization.
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Top navigation bar title.
        navigationItem.title = "Categories"
        
        categoriesTable = UITableView()
        categoriesTable.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoriesCellReuseIdentifier)
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTable)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        categoriesTable.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: categoriesCellReuseIdentifier, for: indexPath) as! CategoryTableViewCell
        let str = categories[indexPath.row]
        
        cell.categoryLabel.text = str.capitalized
        cell.category = str
        cell.selectionStyle = .none
        
        cell.updateCell() // correctly assigns button images.
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // Pushes detail view when cell clicked.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let vc = CategoryDetailViewController(category: category)
        
        // Pushes detailView and gets rid of UITabBarViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
