//
//  DarkNewsListAppearance.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class DarkNewsListAppearance: NewsListAppearance {
    func setup(controller: NewsListViewController) {
        if let navigationController = controller.navigationController {
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        controller.view?.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        controller.articlesCollectionView?.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    func localize(controller: NewsListViewController) {
        controller.navigationItem.title = "News"
        controller.queryTextField.placeholder = "Try search news now!"
    }
}
