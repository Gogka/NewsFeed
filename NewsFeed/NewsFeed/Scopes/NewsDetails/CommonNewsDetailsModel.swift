//
//  CommonNewsDetailsModel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/15/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class NewsKit.Article
import class UIKit.UIImage

class CommonNewsDetailsModel: NewsDetailsModel {
    private enum ImageState {
        case success(UIImage)
        case error
        case suspended(URL)
    }
    private let article: Article
    private weak var output: NewsDetailsModelOutput?
    private var articleImageState: ImageState
    var originURL: URL? { return article.sourceURL }
    init(article: Article) {
        self.article = article
        self.articleImageState = article.imageURL.map({ ImageState.suspended($0) }) ?? .error
    }
    
    func getNewsDetails() {
        output?.didGetNewsDetails(result: .success(article))
        switch articleImageState {
        case .error:
            output?.didGetNewsImage(image: nil)
        case .suspended(let url):
            NetworkLayer.shared.getImageTask(forURL: url, completion: { [weak self] image in
                guard let sSelf = self else { return }
                if let imageUnwrapped = image {
                    sSelf.articleImageState = .success(imageUnwrapped)
                    sSelf.output?.didGetNewsImage(image: image)
                } else {
                    sSelf.articleImageState = .error
                    sSelf.output?.didGetNewsImage(image: nil)
                }
            }).resume()
        case .success(let image):
            output?.didGetNewsImage(image: image)
        }
    }
    
    func detachOutput() {
        output = nil
    }
    
    func attach(output: NewsDetailsModelOutput) {
        self.output = output
    }
    
}
