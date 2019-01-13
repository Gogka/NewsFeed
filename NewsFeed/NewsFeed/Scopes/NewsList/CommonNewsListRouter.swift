//
//  CommonNewsListRouter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit
import NewsKit

class CommonNewsListRouter: NewsListRouter {
    static func createScope() -> NewsListViewController {
        let controller = NewsListViewController()
        let model = CommonNewsListModel(fetcher: NewsFetcher(apiKey: "b59bc1f13f884301a259ebc4a7c68af2", cache: nil))
        let router = CommonNewsListRouter()
        let presenter = NewsListCommonPresenter(model: model, router: router)
        controller.presenter = presenter
        return controller
    }
    
    func navigateToDetails(withArticle article: Article, andCell cell: UICollectionViewCell) {
        
    }

}
