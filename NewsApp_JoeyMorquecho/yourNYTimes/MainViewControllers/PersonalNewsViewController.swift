//
//  PersonalNewsViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/14/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import SnapKit

class PersonalNewsViewController: UIViewController {
    
    var savedCategories:[String] = []  // Will store retrieved array from UserDefaults.
    
    var allArticles:[ArticleFromCategory] = []  // All articles from saved categories.
    
    var collectionView: UICollectionView!
    
    let cellPadding:CGFloat = 12
    let headerViewHeight: CGFloat = 60
    let articlesPerSection = 4  // Articles per section in collection view.
    
    // Reuse Identifiers
    let mainArticlesReuseIdentifier = "mainArticlesReuseIdentifier"
    let sectionReuseIdentifier = "sectionReuseIdentifier"
    let footerReuseIdentifier = "footerReuseIdentifier"
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // Top navigation bar title.
        navigationItem.title = "New York Times"
                
        let verticalLayout = UICollectionViewFlowLayout()
        verticalLayout.scrollDirection = .vertical
        verticalLayout.minimumInteritemSpacing = cellPadding
        verticalLayout.minimumLineSpacing = cellPadding
        verticalLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: headerViewHeight)
                
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalLayout)
        collectionView.backgroundColor = .white
        
        // Registering cell, header view, and footer view.
        collectionView.register(MainArticlesCollectionViewCell.self, forCellWithReuseIdentifier: mainArticlesReuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionReuseIdentifier)
        collectionView.register(HomePageFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        setUpConstraints()
    }
    
    // Will retrieve array of saved categories from UserDefaults.
    override func viewWillAppear(_ animated: Bool) {
        getSavedCategories()
        getAllArticles()
    }
    
    /// Gets saved categories and assigns it to savedCategories array.
    func getSavedCategories() {
        if let array = userDefaults.value(forKey: Constants.UserDefaults.categories) as? [String] {
            self.savedCategories = array
        }
    }
    
    /// Gets all articles in order of categories in savedCategories array.
    func getAllArticles() {
        
        // Background dispatch queue to fetch all articles.
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        // Dispatch Semaphore used to not disrupt order of articles saved.
        let semaphore = DispatchSemaphore(value: 0)
        
        dispatchQueue.async {
                
            self.allArticles.removeAll()
            var temporaryArticles:[ArticleFromCategory] = []  // Temporary articles to filter through.
            
            for category in self.savedCategories {
                
                NetworkManager.getArticles(fromCategory: category) { (articles) in

                    temporaryArticles = articles
                    
                    // Limits number of articles displayed.
                    while temporaryArticles.count > self.articlesPerSection {
                        temporaryArticles.removeLast()
                    }

                    self.allArticles.append(contentsOf: temporaryArticles)
                    semaphore.signal()  // Signals when articles recieved.
                }
                semaphore.wait() // Waits for next set of articles to be sent.
            }
            
            // If there are no categories being 'followed', "home" category is displayed.
            if (self.allArticles.count == 0) {
                self.savedCategories = ["home"]
                NetworkManager.getArticles(fromCategory: "home") { (articles) in

                    temporaryArticles = articles
                    
                    // Limits number of articles displayed.
                    while temporaryArticles.count > self.articlesPerSection {
                        temporaryArticles.removeLast()
                    }

                    self.allArticles.append(contentsOf: temporaryArticles)
                    semaphore.signal()  // Signals when articles recieved.
                }
                semaphore.wait() // Waits for next set of articles to be sent.
            }
            
            // Reloads collection view once all articles are recieved.
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setUpConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}

extension PersonalNewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesPerSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainArticlesReuseIdentifier, for: indexPath) as! MainArticlesCollectionViewCell
                
        // Makes sure that all articles have been loaded.
        if (allArticles.count == savedCategories.count * articlesPerSection) {
                
            // Let variable 'index' is the index of the article in the allArticles array.
            let index = indexPath.item + (self.articlesPerSection * indexPath.section)
            let article = self.allArticles[index]
                    
            cell.headlineTextView.text = article.title
                    
            if article.multimedia.count != 0 {
                let articleImageUrl = article.multimedia[0].url
                if  articleImageUrl != "" {
                        cell.addImage(url: articleImageUrl)
                }
            }
                            
            // Layer customization
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (savedCategories.count == 0) {
            return 1
        } else {
            return savedCategories.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Header View.
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionReuseIdentifier, for: indexPath) as! SectionHeaderView
            headerView.label.text = savedCategories[indexPath.section].capitalized
            
            return headerView
        } else {  // Footer view.
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! HomePageFooterView
            
            footerView.layer.masksToBounds = true  // Gets rid of text when cell height is small.
            return footerView
        }
    }

}

extension PersonalNewsViewController: UICollectionViewDelegate {
    
    // Opens article url.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainArticlesReuseIdentifier, for: indexPath) as! MainArticlesCollectionViewCell
        let index = indexPath.item + (self.articlesPerSection * indexPath.section)
        
        cell.openUrl(urlString: allArticles[index].url)
    }
}

extension PersonalNewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.width - 2 * cellPadding) / 2
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (section == savedCategories.count - 1) {  // Last Section
            return CGSize(width: view.frame.width, height: 40)
        }
        
        return CGSize(width: view.frame.width, height: 1)
    }
}
