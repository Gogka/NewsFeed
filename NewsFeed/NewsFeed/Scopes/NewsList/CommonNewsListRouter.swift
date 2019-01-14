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
        let queue = DispatchQueue(label: "com.igortomilin.CommonNewsListModel")
        let model = CommonNewsListModel(fetcher: NewsFetcher(apiKey: "b59bc1f13f884301a259ebc4a7c68af2", queue: queue),
                                        queue: queue,
                                        articleRepository: CoreDataRepository.shared)
        let router = CommonNewsListRouter(controller: controller)
        let presenter = NewsListCommonPresenter(model: model, router: router)
        controller.presenter = presenter
        return controller
    }
    private weak var controller: NewsListViewController?
    
    init(controller: NewsListViewController) {
        self.controller = controller
    }
    
    func navigateToDetails(withArticle article: Article, andCell cell: UICollectionViewCell) {
        controller?.navigationController?.pushViewController(CommonNewsDetailsRouter.createScope(article: article), animated: true)
    }

}
