//
//  ArticleRepository.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article

protocol ArticleRepository {
    func save(articles: [Article], completion: ((Bool) -> ())?)
    func fetchtArticles(completion: @escaping ([Article]) -> ())
}
