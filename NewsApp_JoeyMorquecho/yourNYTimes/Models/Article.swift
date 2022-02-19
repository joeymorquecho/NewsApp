//
//  Article.swift
//  yourNYTimes
//
//  Created by Joey Morquecho on 5/6/20.
//  Copyright © 2020 Joey Morquecho. All rights reserved.
//

import UIKit
import Foundation

struct ByLineObject: Codable {
    let original: String  // String of format: "By: 'Writer'"
}

struct HeadlineObject: Codable {
    let main: String  // Article Headline
}

struct MultimediaObject: Codable {
    let url: String  // Image url
}

/// Article struct retrieved from NY Times Article Search API.
struct Article: Codable {

    let abstract: String
    let web_url: String
    let headline: HeadlineObject
    let lead_paragraph: String
    let multimedia: [MultimediaObject]
    let byline: ByLineObject
}

struct ArticlesObject: Codable {
    let docs: [Article]
}

struct ArticlesResponse: Codable {
    let response: ArticlesObject
}
