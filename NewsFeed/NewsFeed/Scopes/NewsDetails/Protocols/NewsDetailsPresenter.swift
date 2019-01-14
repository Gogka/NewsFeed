//
//  NewsDetailsPresenter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsDetailsPresenter {
    func attach(view: NewsDetailsView)
    func viewWillAppear()
    func viewWillDisappear()
    func didTapBack()
    func didTapNewsSource()
}
