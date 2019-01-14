//
//  NewsDetailsAppearance.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsDetailsAppearance {
    func setup(_ controller: NewsDetailsViewController)
    func localize(_ controller: NewsDetailsViewController)
}
