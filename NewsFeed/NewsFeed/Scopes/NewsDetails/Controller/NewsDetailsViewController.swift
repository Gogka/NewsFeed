//
//  NewsDetailsViewController.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: InsetsLabel!
    @IBOutlet weak var newsPublishedDate: InsetsLabel!
    @IBOutlet weak var newsUrl: InsetsLabel!
    
    var appearance: NewsDetailsAppearance = DarkNewsDetailsAppearance()
    var presenter: NewsDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        appearance.setup(self)
        appearance.localize(self)
        setupDependencies()
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
    }
    
    private func setupUI() {
        newsUrl?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOriginSourceView(_:))))
        newsUrl?.isUserInteractionEnabled = true
        newsUrl?.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        newsPublishedDate?.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        newsDescription?.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let item = UIBarButtonItem()
        item.target = self
        item.action = #selector(didTapBack(_:))
        item.tintColor = .white
        navigationItem.backBarButtonItem = item
    }
    
    @objc
    private func didTapOriginSourceView(_ view: UIView) {
        presenter?.didTapNewsSource()
    }
    
    @objc
    private func didTapBack(_ item: UIBarButtonItem) {
        presenter?.didTapBack()
    }
}

extension NewsDetailsViewController: NewsDetailsView {
    func setOriginURL(hidden: Bool) {
        newsUrl?.isHidden = hidden
    }
    
    func setNewsImage(_ image: UIImage) {
        newsImageView?.image = image
    }
    
    func setNewsTitle(_ title: String) {
        newsTitle?.text = title
    }
    
    func setNewsDescription(_ description: String) {
        newsDescription?.text = description
    }
    
    func setNewsPublishedDate(_ date: String) {
        newsPublishedDate?.text = date
    }
}
