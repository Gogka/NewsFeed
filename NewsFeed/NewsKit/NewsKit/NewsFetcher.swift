//
//  NewsFetcher.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

public protocol NewsFetcherDelegate: class {
    func fetcher(_ fetcher: NewsFetcher, didReceiveResponse response: ArticlesResponse)
    func fetcher(_ fetcher: NewsFetcher, didReceiveError error: Error)
}

public class NewsFetcher {
    public enum Sorting: String {
        case relevancy, popularity, publishedAt
    }
    private let session: URLSession
    private let urlComponents: URLComponents
    public weak var delegate: NewsFetcherDelegate?
    private var task: URLSessionDataTask?
    private var timer: Timer? {
        willSet { timer?.invalidate() }
    }
    private let decoder = JSONDecoder()
    
    public init(apiKey: String, cache: URLCache? = URLCache(memoryCapacity: 0, diskCapacity: 40 * 1024 * 1024, diskPath: nil)) {
        self.urlComponents = C.everythingUrlComponents.add(items: ["apiKey": apiKey])
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }
    
    public func fetchArticles(byQuery query: String, page: Int = 1, sortBy sorting: Sorting = .publishedAt) {
        guard !query.isEmpty else { delegate?.fetcher(self, didReceiveError: NewsError.emptyQuery); return }
        mainSync {
            self.task?.cancel()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { [weak self] _ in
                guard let `self` = self else { return }
                let items = [
                    "q": query,
                    "sortBy": sorting.rawValue,
                    "page": "\(page)"
                ]
                guard let url = self.urlComponents.add(items: items).url else {
                    self.delegate?.fetcher(self, didReceiveError: NewsError.incorrectURL)
                    return
                }
                self.task = self.session.dataTask(with: url) { [weak self] dataWrapped, urlResponse, errorWrapped in
                    guard let sSelf = self else { return }
                    sSelf.task = nil
                    if let data = dataWrapped, let response = try? sSelf.decoder.decode(ArticlesResponse.self, from: data) {
                        sSelf.delegate?.fetcher(sSelf, didReceiveResponse: response)
                    } else {
                        if (errorWrapped as NSError?)?.code == NSURLErrorCancelled { return }
                        sSelf.delegate?.fetcher(sSelf, didReceiveError: errorWrapped ?? NewsError.noData)
                    }
                }
                self.task?.resume()
            })
        }
    }
    
    public func clearCache() {
        session.configuration.urlCache?.removeAllCachedResponses()
    }
}
