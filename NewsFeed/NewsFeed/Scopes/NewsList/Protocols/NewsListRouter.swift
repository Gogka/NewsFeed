//
//  NewsListRouter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit
import class NewsKit.Article

protocol NewsListRouter {
    func navigateToDetails(withArticle article: Article, andCell cell: UICollectionViewCell)
}
