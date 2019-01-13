//
//  NewsListPresenter.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation

protocol NewsListPresenter {
    func attach(view: NewsListView)
    func viewWillAppear()
    func viewWillDisappear()
    func didChangeSearchText(_ text: String)
    func didShowLastNews()
}
