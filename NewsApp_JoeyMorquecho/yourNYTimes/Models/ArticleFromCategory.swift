//
//  ArticleFromCategory.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/12/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import Foundation


struct MultimediaObj: Codable {
    let url: String  // Image url
}

/// ArticleFromCategory object retrived from NY Times Top Stories API.
struct ArticleFromCategory: Codable {

    let abstract: String
    let url: String
    let title: String
    let multimedia: [MultimediaObj]
}

struct ArticlesResponseFromCategory: Codable {
    let results: [ArticleFromCategory]
}

