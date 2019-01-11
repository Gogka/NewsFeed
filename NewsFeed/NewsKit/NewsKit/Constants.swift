//
//  Constants.swift
//  NewsKit
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

enum C {
    static let everythingUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"
        return components
    }()
}

func mainSync(_ closure: @escaping () -> ()) {
    Thread.isMainThread ? closure() : DispatchQueue.main.sync { closure() }
}
