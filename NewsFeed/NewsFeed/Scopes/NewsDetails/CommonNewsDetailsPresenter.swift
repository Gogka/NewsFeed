//
//  CommonNewsDetailsPresenter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/15/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article
import class UIKit.UIImage

class CommonNewsDetailsPresenter: NewsDetailsPresenter {
    private let model: NewsDetailsModel
    private let router: NewsDetailsRouter
    private weak var view: NewsDetailsView?
    
    init(model: NewsDetailsModel, router: NewsDetailsRouter) {
        self.model = model
        self.router = router
    }
    
    func attach(view: NewsDetailsView) {
        self.view = view
    }
    
    func viewWillAppear() {
        model.attach(output: self)
        model.getNewsDetails()
    }
    
    func viewWillDisappear() {
        model.detachOutput()
    }
    
    func didTapBack() {
        router.back()
    }
    
    func didTapNewsSource() {
        model.originURL.map { router.navigateToNewsSource(url: $0) }
    }
}

extension CommonNewsDetailsPresenter: NewsDetailsModelOutput {
    func didGetNewsDetails(result: Result<Article>) {
        switch result {
        case .error(let error): print(error)
        case .success(let article):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = formatter.date(from: article.publishedDate) ?? Date()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let publishedDate = formatter.string(from: date)
            DispatchQueue.main.async {
                self.view?.setNewsTitle(article.title)
                self.view?.setNewsDescription(article.description)
                self.view?.setOriginURL(hidden: article.sourceURL == nil)
                self.view?.setNewsPublishedDate(publishedDate)
            }
        }
    }
    
    func didGetNewsImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.view?.setNewsImage(image ?? UIImage(imageLiteralResourceName: "noimage"))
        }
    }
    
}
