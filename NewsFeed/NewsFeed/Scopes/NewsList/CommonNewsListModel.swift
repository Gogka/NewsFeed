//
//  CommonNewsListModel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import NewsKit

class CommonNewsListModel: NewsListModel {
    private weak var output: NewsListModelOutput?
    private let fetcher: NewsFetcher
    private let queue: DispatchQueue
    private let articleRepository: ArticleRepository
    private let pageSize: Int
    private var currentPage: Int? = 0
    private var loadingPage: Int?
    private var previousQuery: String?
    
    init(fetcher: NewsFetcher, pageSize: Int = 20, queue: DispatchQueue, articleRepository: ArticleRepository) {
        self.fetcher = fetcher
        self.queue = queue
        self.pageSize = pageSize
        self.articleRepository = articleRepository
        fetcher.delegate = self
    }
    
    func attach(output: NewsListModelOutput) {
        self.output = output
    }
    
    func detachOutput() {
        output = nil
    }
    
    
    func getArticles(byQuery query: String) {
        if query.isEmpty {
            fetcher.invalidate()
            currentPage = nil
            loadingPage = nil
            articleRepository.fetchtArticles(completion: { [weak self] articles in
                self?.queue.async { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.output?.didReceiveNewArticlesResult(.success(articles))
                }
            })
        } else {
            currentPage = 1
            loadingPage = 1
            fetcher.fetchArticles(byQuery: query, page: currentPage!, pageSize: pageSize)
        }
    }
    
    func getMoreArticlesForPreviousQuery() {
        guard loadingPage != currentPage, let previousQuery = self.previousQuery, let page = currentPage else { return }
        loadingPage = page
        fetcher.fetchArticles(byQuery: previousQuery, page: page, pageSize: pageSize)
    }
    
    
}

extension CommonNewsListModel: NewsFetcherDelegate {
    func fetcher(_ fetcher: NewsFetcher, didReceiveResponse response: ArticlesResponse, forQuery query: String) {
        defer { previousQuery = query }
        if previousQuery == query {
            switch response.result {
            case .success(let successResponse):
                if (successResponse.totalResults - loadingPage! * pageSize) > 0 {
                    currentPage! += 1
                } else {
                    currentPage = nil
                }
                output?.didReceiveMoreArticlesForPreviousQuery(.success(successResponse.articles))
            case .error(let errorResponse):
                output?.didReceiveMoreArticlesForPreviousQuery(.error(errorResponse.message))
            }
        } else {
            switch response.result {
            case .success(let successResponse):
                if (successResponse.totalResults - loadingPage! * pageSize) > 0 {
                    currentPage! += 1
                } else {
                    currentPage = nil
                }
                articleRepository.save(articles: successResponse.articles, completion: { [weak self] isSuccess in
                    self?.queue.async { [weak self] in
                        guard let sSelf = self else { return }
                        if isSuccess {
                            sSelf.output?.didReceiveNewArticlesResult(.success(successResponse.articles))
                        } else {
                            sSelf.output?.didReceiveNewArticlesResult(.error("Saving error"))
                        }
                    }
                })
            case .error(let errorResponse):
                output?.didReceiveNewArticlesResult(.error(errorResponse.message))
            }
        }
    }
    
    func fetcher(_ fetcher: NewsFetcher, didReceiveError error: Error, forQuery query: String) {
        defer { previousQuery = query }
        if previousQuery == query {
            output?.didReceiveMoreArticlesForPreviousQuery(.error(error.localizedDescription))
        } else {
            output?.didReceiveNewArticlesResult(.error(error.localizedDescription))
        }
    }
}
