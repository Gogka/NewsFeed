//
//  NewsListView.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsListView: class {
    func updateCollection(_ newArticles: [NewsElementViewModel])
    func addArticles(_ newArticles: [NewsElementViewModel])
    func handleError(error: String)
}
