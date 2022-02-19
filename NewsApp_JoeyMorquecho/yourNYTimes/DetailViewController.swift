//
//  DetailViewController.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/9/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import SnapKit

// DetailViewController displays detailed view of article from search.
class DetailViewController: UIViewController, UITextViewDelegate {
        
    var articleHeadline: UILabel!
    var abstractTextView: UITextView!
    var byLineLabel: UILabel!
    var articleSnippet: UITextView!
    var imageView: UIImageView!
    var urlTextView: UITextView!
    
    var scrollView: UIScrollView!
    var containerView: UIView!  // Contains all view elements.
    
    var abstractText: String!
    var headline: String!
    var byLineText: String!
    var leadParagraph: String!
    var imageUrl: String!
    var url: String!
    
    let containerViewHeight = 850  // Height of entire detail view in scroll view.
    
    init (abstract: String, headline: String, byLine: String, snippet: String, imageUrl: String, webUrl: String) {
        super .init(nibName: nil, bundle: nil)
        
        self.headline = headline
        self.abstractText = abstract
        self.byLineText = byLine
        self.leadParagraph = "\(snippet) ..."
        self.imageUrl = imageUrl
        self.url = webUrl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        let contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = contentSize
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.contentSize = contentSize
        view.addSubview(scrollView)

        scrollView.addSubview(containerView)
        
        articleHeadline = UILabel()
        articleHeadline.textAlignment = .left
        articleHeadline.text = headline
        articleHeadline.font = UIFont.boldSystemFont(ofSize: 22)
        articleHeadline.numberOfLines = 0
        articleHeadline.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(articleHeadline)
        
        abstractTextView = UITextView()
        abstractTextView.text = abstractText
        abstractTextView.font = UIFont.init(name: "Georgia", size: 19)
        abstractTextView.textColor = .gray
        abstractTextView.isEditable = false
        abstractTextView.isScrollEnabled = false
        abstractTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(abstractTextView)
        
        byLineLabel = UILabel()
        byLineLabel.text = byLineText
        byLineLabel.textAlignment = .left
        byLineLabel.font = UIFont.boldSystemFont(ofSize: 16)
        byLineLabel.textColor = .black
        byLineLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(byLineLabel)
        
        articleSnippet = UITextView()
        articleSnippet.text = leadParagraph
        articleSnippet.font = UIFont.init(name: "Georgia", size: 18)
        articleSnippet.isEditable = false
        articleSnippet.isScrollEnabled = false
        articleSnippet.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(articleSnippet)
        
        imageView = UIImageView()
        // Sets image from image url.
        if imageUrl != "" {
            NetworkManager.getArticleImage(fromPartialUrl: imageUrl) { (image) in
                self.imageView.image = image
            }
        }
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        containerView.addSubview(imageView)
        
        urlTextView = UITextView()
        urlTextView.text = url
        urlTextView.delegate = self
        urlTextView.isEditable = false
        urlTextView.isScrollEnabled = false
        urlTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(urlTextView)
        
        addUrl(url: url) // Adds 'clickable' link to urlTextView.
        urlTextView.textAlignment = .center
        urlTextView.font = UIFont.boldSystemFont(ofSize: 18)
        urlTextView.tintColor = .black
    
        setUpConstraints()
    }
    
    /// Configures the recipe's url as a clickable link.
    func addUrl(url: String) {
        let str = "Read More" as NSString
        let attributedString = NSMutableAttributedString(string: "Read More")
        
        attributedString.addAttribute(.link, value: URL(string: url)!, range: NSRange(location: 0, length: str.length))
        urlTextView.attributedText = attributedString
    }
    
    // Opens webpage when link is clicked.
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    func setUpConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(containerViewHeight)
        }
        
        articleHeadline.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(20)
            make.height.equalTo(80)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        abstractTextView.snp.makeConstraints { (make) in
            make.top.equalTo(articleHeadline.snp.bottom)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        if (imageUrl != ""){ // Optimizes space for image
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(abstractTextView.snp.bottom).offset(0)
                make.height.equalTo(300)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        } else {
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(abstractTextView.snp.bottom).offset(10)
                make.height.equalTo(1)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        byLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        articleSnippet.snp.makeConstraints { (make) in
            make.top.equalTo(byLineLabel.snp.bottom).offset(0)
            make.height.equalTo(200)
            make.width.equalTo(view.frame.width - 30)
            make.centerX.equalToSuperview() 
        }
        
        urlTextView.snp.makeConstraints { (make) in
            make.top.equalTo(articleSnippet.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
    }
}
