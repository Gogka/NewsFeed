//
//  NewsDetailsModelOutput.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article
import class UIKit.UIImage

protocol NewsDetailsModelOutput: class {
    func didGetNewsDetails(result: Result<Article>)
    func didGetNewsImage(image: UIImage?)
}
