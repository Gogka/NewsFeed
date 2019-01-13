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
    
    func attach(collection: UICollectionView) {
        self.collection = collection
        collection.register(UINib(nibName: "NewsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CommonNewListCollectionHandler.cellIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        collection.isPrefetchingEnabled = true
    }
    
    func updateCollection(_ newArticles: [NewsElementViewModel]) {
        collection?.performBatchUpdates({
            elements = newArticles
            let indexes = (0..<newArticles.count).map({ IndexPath(row: $0, section: 0) })
            collection?.insertItems(at: indexes)
        })
    }
    
    func clear() {
        collection?.performBatchUpdates({
            let indexes = (0..<elements.count).map({ IndexPath(row: $0, section: 0) })
            elements = []
            collection?.deleteItems(at: indexes)
        })
    }
    
    func addArticles(_ newArticles: [NewsElementViewModel]) {
        collection?.performBatchUpdates({
            let indexes = (elements.count..<newArticles.count).map({ IndexPath(row: $0, section: 0) })
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
        cell.newsTitle?.text = element.title
        cell.newsImageVIew?.image = UIImage(imageLiteralResourceName: "noimage")
        element.getImage(completion: { [weak weakCell = cell] image in
            image.map { weakCell?.newsImageVIew?.image = $0 }
        })
        return cell
    }
}

extension CommonNewListCollectionHandler: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].didTapCell(cell: collectionView.cellForItem(at: indexPath)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height * 0.4)
    }
}

extension CommonNewListCollectionHandler: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { elements[$0.row].prefetch() }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { elements[$0.row].cancelPrefetch() }
    }
}
