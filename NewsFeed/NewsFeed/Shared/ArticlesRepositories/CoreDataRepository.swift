//
//  CoreDataRepository.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import CoreData
import class NewsKit.Article

class CoreDataRepository: ArticleRepository {
    private let container = NSPersistentContainer(name: "NewsFeedModel")
    private let queue = DispatchQueue(label: "com.igortomilin.CoreDataRepository")
    
    static let shared = CoreDataRepository()
    private init() {
        container.loadPersistentStores(completionHandler: { _, error in
            error.map { print($0) }
        })
    }
    
    func save(articles: [Article], completion: ((Bool) -> ())?) {
        queue.async {
            let context = self.container.viewContext
            articles.forEach {
                let cdArticle = CDArticle(context: context)
                cdArticle.articleDescription = $0.description
                cdArticle.author = $0.author
                cdArticle.content = $0.content
                let source = CDSource(context: context)
                source.id = $0.source.id
                source.name = $0.source.name
                cdArticle.source = source
                source.article = cdArticle
                cdArticle.imageURL = $0.imageURL?.absoluteString
                cdArticle.sourceURL = $0.sourceURL?.absoluteString
                cdArticle.publishedDate = $0.publishedDate
                cdArticle.title = $0.title
            }
            do {
                try context.save()
                completion?(true)
            } catch {
                completion?(false)
            }
        }
    }
    
    func fetchtArticles(completion: @escaping ([Article]) -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<CDArticle>(entityName: "CDArticle")
            let articles = (try? self.container.viewContext.fetch(fetchRequest)) ?? []
            completion(articles.compactMap({ Article(article: $0) }))
        }
    }
    
}

extension Article {
    convenience init?(article: CDArticle) {
        guard let source = article.source.map({ Article.Source(source: $0) }) ?? nil, let author = article.author, let title = article.title, let description = article.articleDescription, let publishedDate = article.publishedDate, let content = article.content else { return nil }
        self.init(author: author,
                  title: title,
                  source: source,
                  description: description,
                  imageURL: article.imageURL.map({ URL(string:$0) }) ?? nil,
                  sourceURL: article.sourceURL.map({ URL(string:$0) }) ?? nil,
                  publishedDate: publishedDate,
                  content: content)
    }
}

extension Article.Source {
    convenience init?(source: CDSource) {
        guard let name = source.name else { return nil }
        self.init(id: source.id, name: name)
    }
}
