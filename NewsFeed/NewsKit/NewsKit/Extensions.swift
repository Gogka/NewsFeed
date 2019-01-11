//
//  Extensions.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

extension URLComponents {
    func add(items: [String: String]) -> URLComponents {
        var components = self
        components.queryItems = (queryItems ?? []) + items.map({ URLQueryItem(name: $0, value: $1) })
        return components
    }
}

extension KeyedDecodingContainer {
    func decodeArraySafety<Object: Decodable>(key: K) throws -> [Object] {
        return (try decode([SafetyDecodable<Object>].self, forKey: key)).compactMap({ $0.value })
    }
    
}

private class SafetyDecodable<Object: Decodable>: Decodable {
    let value: Object?
    required public init(from decoder: Decoder) throws {
        value = try? decoder.singleValueContainer().decode(Object.self)
    }
}
