//
//  NewsListModel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsListModel {
    func attach(output: NewsListModelOutput)
    func detachOutput()
    func getArticles(byQuery query: String)
    func getMoreArticlesForPreviousQuery()
}
