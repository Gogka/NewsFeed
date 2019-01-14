//
//  CommonNewsDetailsRouter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/15/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class UIKit.UIApplication
import class NewsKit.Article

class CommonNewsDetailsRouter: NewsDetailsRouter {
    static func createScope(article: Article) -> NewsDetailsViewController {
        let controller = NewsDetailsViewController()
        let model = CommonNewsDetailsModel(article: article)
        let router = CommonNewsDetailsRouter(controller: controller)
        let presenter = CommonNewsDetailsPresenter(model: model, router: router)
        controller.presenter = presenter
        return controller
    }
    
    private weak var controller: NewsDetailsViewController?
    
    init(controller: NewsDetailsViewController) {
        self.controller = controller
    }
    
    func back() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToNewsSource(url: URL) {
        UIApplication.shared.open(url)
    }
    
}
