//
//  Article.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

public class Article: Decodable {
    public class Source: Decodable {
        public let id: String?
        public let name: String
        
        public init(id: String?, name: String) {
            self.id = id
            self.name = name
        }
    }
    public let source: Source
    public let author: String
    public let title: String
    public let description: String
    public let imageURL: URL?
    public let sourceURL: URL?
    public let publishedDate: String
    public let content: String
    
    enum Keys: String, CodingKey {
        case source
        case author
        case title
        case description
        case imageURL = "urlToImage"
        case sourceURL = "url"
        case publishedDate = "publishedAt"
        case content
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        source = try container.decode(Source.self, forKey: .source)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        publishedDate = try container.decode(String.self, forKey: .publishedDate)
        content = try container.decode(String.self, forKey: .content)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
        sourceURL = try container.decode(URL.self, forKey: .sourceURL)
    }
    
    public init(author: String, title: String, source: Source, description: String, imageURL: URL?, sourceURL: URL?, publishedDate: String, content: String) {
        self.author = author
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.sourceURL = sourceURL
        self.publishedDate = publishedDate
        self.content = content
        self.source = source
    }
}
