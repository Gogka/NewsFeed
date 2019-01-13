//
//  NewsListAppearance.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsListAppearance {
    func setup(controller: NewsListViewController)
    func localize(controller: NewsListViewController)
}
