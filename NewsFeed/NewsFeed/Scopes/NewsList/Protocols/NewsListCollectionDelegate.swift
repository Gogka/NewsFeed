//
//  NewsListCollectionDelegate.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

protocol NewsListCollectionHandler {
    func attach(collection: UICollectionView)
    func updateCollection(_ newArticles: [NewsElementViewModel])
    func clear()
    func addArticles(_ newArticles: [NewsElementViewModel])
}
