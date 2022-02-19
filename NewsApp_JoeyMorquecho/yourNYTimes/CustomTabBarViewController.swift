//
//  CustomTabBarViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// Bottom TabBarViewController
class CustomTabBarViewController: UITabBarController {
    
//    let tintColor = UIColor(red: 35/255, green: 180/255, blue: 115/255, alpha: 1)
    let orangeTintColor = UIColor(red: 255/255, green: 140/255, blue: 40/255, alpha: 1)

    let magnifyingGlassImage = UIImage(systemName: "magnifyingglass")
    let categoryImage = UIImage(systemName: "square.stack.fill")
    let bookImage = UIImage(systemName: "book.fill")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainView = PersonalNewsViewController()
        let mainViewNavController = UINavigationController(rootViewController: mainView)
        mainViewNavController.tabBarItem = UITabBarItem(title: "Your News", image: bookImage, selectedImage: bookImage)
        mainViewNavController.navigationBar.barTintColor = .white
        mainViewNavController.navigationBar.backgroundColor = .white
        mainViewNavController.navigationBar.tintColor = orangeTintColor
        
        let categoriesView = CategoriesViewController()
        let categoriesViewNavController = UINavigationController(rootViewController: categoriesView)
        categoriesViewNavController.tabBarItem = UITabBarItem(title: "Categories", image: categoryImage, selectedImage: categoryImage)
        categoriesViewNavController.navigationBar.barTintColor = .white
        categoriesViewNavController.navigationBar.backgroundColor = .white
        categoriesViewNavController.navigationBar.tintColor = orangeTintColor
        
        let searchView = SearchViewController()
        let searchViewNavController = UINavigationController(rootViewController: searchView)
        searchViewNavController.tabBarItem = UITabBarItem(title: "Search", image: magnifyingGlassImage, selectedImage: magnifyingGlassImage)
        searchViewNavController.navigationBar.barTintColor = .white
        searchViewNavController.navigationBar.backgroundColor = .white
        searchViewNavController.navigationBar.tintColor = orangeTintColor
        
        
        // Top navigation bar tint color.
        tabBar.tintColor = orangeTintColor
        
        viewControllers = [mainViewNavController ,categoriesViewNavController, searchViewNavController]
    }
}
