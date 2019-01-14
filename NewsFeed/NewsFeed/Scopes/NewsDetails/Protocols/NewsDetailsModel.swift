//
//  NewsDetailsModel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsDetailsModel {
    var originURL: URL? { get }
    func getNewsDetails()
    func attach(output: NewsDetailsModelOutput)
    func detachOutput()
}
