//
//  NewsListViewController.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/12/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    var appearence: NewsListAppearance = DarkNewsListAppearance()
    var presenter: NewsListPresenter?
    var collectionHandler: NewsListCollectionHandler = CommonNewListCollectionHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
        appearence.setup(controller: self)
        appearence.localize(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    private func setupDependencies() {
        assert(presenter != nil, "Presenter mustn't be nil")
        presenter?.attach(view: self)
        articlesCollectionView.map { collectionHandler.attach(collection: $0) }
        collectionHandler.willShowLastItem = { [weak self] in
            self?.presenter?.didShowLastNews()
        }
        queryTextField?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        queryTextField?.delegate = self
    }
    
    @objc
    private func textDidChange(_ field: UITextField) {
        collectionHandler.clear()
        field.text.map { presenter?.didChangeSearchText($0) }
    }
}

extension NewsListViewController: NewsListView {
    func handleError(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func updateCollection(_ newArticles: [NewsElementViewModel]) {
        collectionHandler.updateCollection(newArticles)
    }
    
    func addArticles(_ newArticles: [NewsElementViewModel]) {
        collectionHandler.addArticles(newArticles)
    }
}

extension NewsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
