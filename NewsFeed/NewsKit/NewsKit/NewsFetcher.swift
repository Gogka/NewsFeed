//
//  NewsFetcher.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

public protocol NewsFetcherDelegate: class {
    func fetcher(_ fetcher: NewsFetcher, didReceiveResponse response: ArticlesResponse, forQuery query: String)
    func fetcher(_ fetcher: NewsFetcher, didReceiveError error: Error, forQuery query: String)
}

public class NewsFetcher {
    public enum Sorting: String {
        case relevancy, popularity, publishedAt
    }
    private let session: URLSession
    private let queue: DispatchQueue
    private let urlComponents: URLComponents
    public weak var delegate: NewsFetcherDelegate?
    private var task: URLSessionDataTask?
    private var timer: Timer?
    private let decoder = JSONDecoder()
    
    public init(apiKey: String, queue: DispatchQueue = .main, cache: URLCache? = URLCache(memoryCapacity: 0, diskCapacity: 40 * 1024 * 1024, diskPath: nil)) {
        self.urlComponents = C.everythingUrlComponents.add(items: ["apiKey": apiKey])
        self.queue = queue
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }
    
    public func fetchArticles(byQuery query: String, page: Int = 1, sortBy sorting: Sorting = .publishedAt, pageSize: Int = 20) {
        invalidate()
        guard !query.isEmpty else {
            queue.async { [weak self] in
                guard let sSelf = self else { return }
                sSelf.delegate?.fetcher(sSelf, didReceiveError: NewsError.emptyQuery, forQuery: query)
            }
            return
        }
        mainSync {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { [weak self] _ in
                guard let `self` = self else { return }
                let items = [
                    "q": query,
                    "sortBy": sorting.rawValue,
                    "page": "\(page)",
                    "pageSize": "\(pageSize)"
                ]
                guard let url = self.urlComponents.add(items: items).url else {
                    self.queue.async { [weak self] in
                        guard let sSelf = self else { return }
                        sSelf.delegate?.fetcher(sSelf, didReceiveError: NewsError.incorrectURL, forQuery: query)
                    }
                    return
                }
                self.task = self.session.dataTask(with: url) { [weak self] dataWrapped, urlResponse, errorWrapped in
                    guard let sSelf = self else { return }
                    sSelf.task = nil
                    if let data = dataWrapped, let response = try? sSelf.decoder.decode(ArticlesResponse.self, from: data) {
                        sSelf.queue.async { [weak sSelf] in
                            sSelf.map { $0.delegate?.fetcher($0, didReceiveResponse: response, forQuery: query) }
                        }
                    } else {
                        if (errorWrapped as NSError?)?.code == NSURLErrorCancelled { return }
                        sSelf.queue.async { [weak sSelf] in
                            sSelf.map { $0.delegate?.fetcher($0, didReceiveError: errorWrapped ?? NewsError.noData, forQuery: query) }
                        }
                    }
                }
                self.task?.resume()
            })
        }
    }
    
    public func clearCache() {
        session.configuration.urlCache?.removeAllCachedResponses()
    }
    
    public func invalidate() {
        task?.cancel()
        mainSync { self.timer?.invalidate() }
    }
}
