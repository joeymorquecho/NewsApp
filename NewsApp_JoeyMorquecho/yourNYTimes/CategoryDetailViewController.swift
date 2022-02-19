//
//  CategoryDetailViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit

// CategoryDetailViewController displays collection view of relevant articles.
class CategoryDetailViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var articles:[ArticleFromCategory] = []
    var category:String = ""
    
    let cellPadding:CGFloat = 12
    let numberOfArticles = 8  // Number of articles to present in collectionView.
    let articleCollectionCellReuseIdentifier = "articleCollectionCellReuseIdentifier"
    
    init(category: String) {
        super .init(nibName: nil, bundle: nil)
        self.category = category
        
        NetworkManager.getArticles(fromCategory: category) { (articles) in
            self.articles = articles
            
            // Limits number of articles displayed to 8.
            while self.articles.count > self.numberOfArticles {
                self.articles.removeLast()
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Top navigation bar title.
        navigationItem.title = category.capitalized
        
        let verticalLayout = UICollectionViewFlowLayout()
        verticalLayout.scrollDirection = .vertical
        verticalLayout.minimumInteritemSpacing = cellPadding
        verticalLayout.minimumLineSpacing = cellPadding
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalLayout)
        collectionView.backgroundColor = .white
        
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: articleCollectionCellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        setUpConstraints()
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

extension CategoryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionCellReuseIdentifier, for: indexPath) as! ArticleCollectionViewCell
        let article = articles[indexPath.item]
        
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
        
        return cell
    }
}

extension CategoryDetailViewController: UICollectionViewDelegate {
    // Open article url when pressed.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionCellReuseIdentifier, for: indexPath) as! ArticleCollectionViewCell
        
        cell.openUrl(urlString: articles[indexPath.item].url)
    }
}

extension CategoryDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.width - 2 * cellPadding) / 2
        return CGSize(width: size, height: size * 1.5)
    }
}
