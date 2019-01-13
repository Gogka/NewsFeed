//
//  NewsListCommonPresenter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article

class NewsListCommonPresenter: NewsListPresenter {
    private weak var view: NewsListView?
    private let model: NewsListModel
    private let router: NewsListRouter
    
    init(model: NewsListModel, router: NewsListRouter) {
        self.model = model
        self.router = router
    }
    
    func attach(view: NewsListView) {
        self.view = view
    }
    
    func viewWillAppear() {
        model.attach(output: self)
    }
    
    func viewWillDisappear() {
        model.detachOutput()
    }
    
    func didChangeSearchText(_ text: String) {
        model.getArticles(byQuery: text)
    }
    
    func didShowLastNews() {
        model.getMoreArticlesForPreviousQuery()
    }
    
    private func map(articles: [Article]) -> [NewsElementViewModel] {
        return articles.map { article in
            NewsElementViewModel(title: article.title, imageURL: article.imageURL, didTapCellAction: { [weak self] cell in
                self?.router.navigateToDetails(withArticle: article, andCell: cell)
            })
        }
    }
}

extension NewsListCommonPresenter: NewsListModelOutput {
    func didReceiveNewArticlesResult(_ result: Result<[Article]>) {
        switch result {
        case .error(let error):
            DispatchQueue.main.async { self.view?.handleError(error: error) }
        case .success(let articles):
            let elements = map(articles: articles)
            DispatchQueue.main.async { self.view?.updateCollection(elements) }
        }
    }
    
    func didReceiveMoreArticlesForPreviousQuery(_ result: Result<[Article]>) {
        switch result {
        case .error(let error):
            DispatchQueue.main.async { self.view?.handleError(error: error) }
        case .success(let articles):
            let elements = map(articles: articles)
            DispatchQueue.main.async { self.view?.addArticles(elements) }
        }
    }
}
