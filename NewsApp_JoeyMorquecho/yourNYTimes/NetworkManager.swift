//
//  NetworkManager.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/5/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ExampleDataResponse<T: Any> {
    case success(data: T)
    case failure(error: Error)
}

class NetworkManager {
    
    private static let nyTimesUrl = "https://api.nytimes.com/svc/search/v2/articlesearch.json"
    private static let nyTimesTopStoriesBeginning = "https://api.nytimes.com/svc/topstories/v2/"
    private static let apiKey = "uYFJxXGakPYTHvFAPN1Tg4yIU24SorE7"
    
    // Gets array of articles from NYTimes Article Search API.
    static func getArticles(fromSearch search: String, completion: @escaping ([Article]) -> Void) {
        
        let parameter: Parameters = [
            "api-key": apiKey,
            "q": search
        ]
        
        AF.request(nyTimesUrl, method: .get, parameters: parameter).validate().responseData { (response) in
            
            switch response.result{
            case .success(let data):
                
                let decoder = JSONDecoder()
                
                if let articleResponse = try? decoder.decode(ArticlesResponse.self, from: data) {
                                    
                    completion(articleResponse.response.docs)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Gets array of articles from NYTimes Top Stories API.
    static func getArticles(fromCategory category: String, completion: @escaping ([ArticleFromCategory]) -> Void) {
        let parameter: Parameters = [
            "api-key": apiKey
        ]
        let url = nyTimesTopStoriesBeginning + category + ".json"
        AF.request(url, method: .get, parameters: parameter).validate().responseData { (response) in

            switch response.result{
            case .success(let data):
                let decoder = JSONDecoder()
                
                if let articleResponse = try? decoder.decode(ArticlesResponseFromCategory.self, from: data) {
                    completion(articleResponse.results)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Get UIImage from Partial imageUrl. (requires "http://www.nytimes.com/" in the front)
    static func getArticleImage(fromPartialUrl imageUrl: String, completion: @escaping (UIImage) -> Void) {
        let fullUrl = "http://www.nytimes.com/" + imageUrl
        
        AF.request(fullUrl, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Invalid image data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Get UIImage from Full imageUrl.
    static func getArticleImage(fromFullUrl imageUrl: String, completion: @escaping (UIImage) -> Void) {
        
        AF.request(imageUrl, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Invalid image data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
