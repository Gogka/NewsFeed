//
//  NewsError.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

public enum NewsError: Error, LocalizedError {
    case incorrectURL
    case noData
    case errorWithDescription(String)
    case emptyQuery
    
    public var errorDescription: String? {
        switch self {
        case .incorrectURL: return "Incorrect url"
        case .noData: return "No have data by request"
        case .errorWithDescription(let description): return description
        case .emptyQuery: return "Query can't be empty"
        }
    }
}
