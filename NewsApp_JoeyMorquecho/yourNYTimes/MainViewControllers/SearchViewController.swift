//
//  SearchViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/5/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import SnapKit

// SearchViewController displays table view of search results.
class SearchViewController: UIViewController {
    
    var searchTask: DispatchWorkItem? // DispatchWorkItem of possible article search query.
    
    var articles: [Article] = []
    
    var tableView: UITableView!
    var searchController: UISearchController!
    
    let cellHeight: CGFloat = 125
    let searchArticlesReuseIdentifier = "searchArticlesReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top navigation bar title.
        navigationItem.title = "Article Search"
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: searchArticlesReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = 125
        view.addSubview(tableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
     
        setUpConstraints()
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchArticlesReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        
        // Configures cell depending if image is available.
        if (article.multimedia.count != 0){
            cell.configure(headline: article.headline.main, imageUrl: article.multimedia[0].url)
        } else {
            cell.configure(headline: article.headline.main, imageUrl: "")

        }
        cell.selectionStyle = .none
                
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // Detail view pushed when cell clicked.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = articles[indexPath.row]
        var imageUrl = ""
        
        if article.multimedia.count != 0 {
            imageUrl = article.multimedia[0].url
        }
        
        let vc = DetailViewController(abstract: article.abstract,headline: article.headline.main, byLine: article.byline.original, snippet: article.lead_paragraph, imageUrl: imageUrl, webUrl: article.web_url)
        
        // Pushes detailView and gets rid of UITabBarViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // Optimized for quicktyping and making efficient API requests.
    func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            if !searchBarText.isEmpty {
                
                searchTask?.cancel()  // Cancels previous request if search bar is updated quickly.
                
                let requestSearchTask = DispatchWorkItem { [weak self] in
                    NetworkManager.getArticles(fromSearch: searchBarText) { (articles) in
                        self?.articles = articles
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
                
                self.searchTask = requestSearchTask
                
                // Will run search query after 0.75 seconds.
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: requestSearchTask)
            }
            else {
                self.articles = []
                self.tableView.reloadData()
            }
        }
    }
}
