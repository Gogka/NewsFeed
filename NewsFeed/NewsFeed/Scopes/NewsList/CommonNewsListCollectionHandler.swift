//
//  CommonNewsListCollectionHandler.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class CommonNewListCollectionHandler: NSObject, NewsListCollectionHandler {
    private static let cellIdentifier = "cellIdentifier"
    private weak var collection: UICollectionView?
    private var elements = [NewsElementViewModel]()
    private let backgroundView: UIView = {
        let label = UILabel()
        label.text = "Not found"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var willShowLastItem: (() -> ())?
    
    func attach(collection: UICollectionView) {
        self.collection = collection
        collection.backgroundView = backgroundView
        collection.register(UINib(nibName: "NewsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CommonNewListCollectionHandler.cellIdentifier)
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collection.dataSource = self
        collection.prefetchDataSource = self
        collection.isPrefetchingEnabled = true
    }
    
    func updateCollection(_ newArticles: [NewsElementViewModel]) {
        collection?.performBatchUpdates({
            elements = newArticles
            let indexes = (0..<newArticles.count).map({ IndexPath(row: $0, section: 0) })
            collection?.insertItems(at: indexes)
        }, completion: { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.activityIndicator.stopAnimating()
            if sSelf.elements.isEmpty {
                sSelf.collection?.backgroundView = sSelf.backgroundView
            } else {
                sSelf.collection?.backgroundView = nil
            }
        })
    }
    
    func clear() {
        if !activityIndicator.isAnimating {
            collection?.backgroundView = activityIndicator
            activityIndicator.startAnimating()
        }
        collection?.performBatchUpdates({
            let indexes = (0..<elements.count).map({ IndexPath(row: $0, section: 0) })
            elements = []
            collection?.deleteItems(at: indexes)
        })
    }
    
    func addArticles(_ newArticles: [NewsElementViewModel]) {
        collection?.performBatchUpdates({
            let indexes = (elements.count..<elements.count + newArticles.count).map({ IndexPath(row: $0, section: 0) })
            elements += newArticles
            collection?.insertItems(at: indexes)
        })
    }
}

extension CommonNewListCollectionHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonNewListCollectionHandler.cellIdentifier, for: indexPath) as? NewsCollectionViewCell else { return .init() }
        let element = elements[indexPath.row]
        cell.imageIdentifier = element.identifier
        cell.newsTitle?.text = element.title
        cell.isSeen = element.isSeen
        cell.newsImageVIew?.image = UIImage(imageLiteralResourceName: "noimage")
        element.getImage(completion: { [weak weakCell = cell, weak weakElement = element] image in
            guard weakCell?.imageIdentifier == weakElement?.identifier else { return }
            image.map { weakCell?.newsImageVIew?.image = $0 }
        })
        return cell
    }
}

extension CommonNewListCollectionHandler: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].didTapCell(cell: collectionView.cellForItem(at: indexPath)!)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == elements.count - 1 {
            willShowLastItem?()
        }
    }
}

extension CommonNewListCollectionHandler: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { elements.element(at: $0.row)?.prefetch() }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { elements.element(at: $0.row)?.cancelPrefetch() }
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
