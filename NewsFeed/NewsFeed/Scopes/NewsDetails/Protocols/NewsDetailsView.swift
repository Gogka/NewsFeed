//
//  NewsDetailsView.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

protocol NewsDetailsView: class {
    func setNewsImage(_ image: UIImage)
    func setNewsTitle(_ title: String)
    func setNewsDescription(_ description: String)
    func setNewsPublishedDate(_ date: String)
    func setOriginURL(hidden: Bool)
}
