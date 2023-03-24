//
//  ArticleModel.swift
//  NewsAPI
//
//  Created by Saruar on 17.03.2023.
//

import Foundation


struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let author: String?
    let description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
}

struct Source: Codable{
    let id: String?
    let name: String?
}
