//
//  DarkNewsDetailsAppearance.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/15/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class DarkNewsDetailsAppearance: NewsDetailsAppearance {
    func setup(_ controller: NewsDetailsViewController) {
        controller.newsDescription?.font = UIFont.systemFont(ofSize: 14)
        controller.newsDescription?.textColor = .white
        controller.newsTitle?.font = UIFont.systemFont(ofSize: 17)
        controller.newsTitle?.textColor = .white
        controller.newsPublishedDate?.textColor = .lightGray
        controller.newsPublishedDate?.font = UIFont.systemFont(ofSize: 12)
        controller.view?.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    func localize(_ controller: NewsDetailsViewController) {
        controller.navigationItem.title = ""
        controller.navigationItem.backBarButtonItem?.title = "Back"
        controller.newsUrl?.attributedText = NSAttributedString(string: "Origin source",
                                                                attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                             .foregroundColor: UIColor.lightGray,
                                                                             .underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    
}
