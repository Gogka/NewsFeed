//
//  Result.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

enum Result<Object> {
    case success(Object)
    case error(String)
}
