//
//  NewsListModelOutput.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article

protocol NewsListModelOutput: class {
    func didReceiveNewArticlesResult(_ result: Result<[Article]>)
    func didReceiveMoreArticlesForPreviousQuery(_ result: Result<[Article]>)
}
