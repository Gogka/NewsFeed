//
//  NewsElementViewModel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class NewsElementViewModel {
    let title: String
    let identifier: String?
    var isSeen = false
    private var task: URLSessionDataTask?
    private var onCompletion: ((UIImage?) -> ())?
    private var image: UIImage?
    private var didTapCellAction: (UICollectionViewCell) -> ()
    
    init(title: String, imageURL: URL?, didTapCellAction: @escaping (UICollectionViewCell) -> ()) {
        self.title = title
        self.identifier = imageURL?.absoluteString
        self.didTapCellAction = didTapCellAction
        if let url = imageURL {
            task = NetworkLayer.shared.getImageTask(forURL: url, completion: { [weak self] image in
                guard let sSelf = self else { return }
                DispatchQueue.main.async {
                    sSelf.onCompletion?(image)
                    sSelf.image = image
                }
            })
        }
    }
    
    func getImage(completion: @escaping (UIImage?) -> ()) {
        if let image = self.image {
            completion(image)
        } else if task != nil {
            onCompletion = completion
            startloading()
        } else {
            completion(nil)
        }
    }
    
    func prefetch() {
        startloading()
    }
    
    func cancelPrefetch() {
        task?.suspend()
    }
    
    func didTapCell(cell: UICollectionViewCell) {
        isSeen = true
        didTapCellAction(cell)
    }
    
    private func startloading() {
        guard let task = self.task, ![URLSessionDataTask.State.completed, .running].contains(task.state) else { return }
        task.resume()
    }
    
}
