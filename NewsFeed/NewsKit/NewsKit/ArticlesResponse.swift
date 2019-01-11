//
//  ArticlesResponse.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

public class ArticlesResponse: Decodable {
    public enum Result {
        case success(ArticlesSuccessResponse)
        case error(ArticlesErrorResponse)
    }
    public let result: Result
    
    enum Keys: String, CodingKey {
        case status
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let status = try container.decode(String.self, forKey: .status)
        if status == "ok" {
            let response = try decoder.singleValueContainer().decode(ArticlesSuccessResponse.self)
            result = .success(response)
        } else {
            let response = try decoder.singleValueContainer().decode(ArticlesErrorResponse.self)
            result = .error(response)
        }
    }
}

public class ArticlesSuccessResponse: Decodable {
    public let articles: [Article]
    public let totalResults: Int
    
    enum Keys: String, CodingKey {
        case articles, totalResults
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        articles = try container.decodeArraySafety(key: .articles)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
    }
}

public class ArticlesErrorResponse: Decodable {
    public let code: String
    public let message: String
}
