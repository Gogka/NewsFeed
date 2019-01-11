//
//  ViewController.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/11/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit
import NewsKit

class ViewController: UIViewController, UITableViewDataSource, NewsFetcherDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let fetcher = NewsFetcher(apiKey: "b59bc1f13f884301a259ebc4a7c68af2")
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.addTarget(self, action: #selector(textDidChange(field:)), for: .editingChanged)
        tableView?.dataSource = self
        fetcher.delegate = self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell()
        cell.textLabel?.text = articles[indexPath.row].title
        return cell
    }
    
    @objc
    func textDidChange(field: UITextField) {
        fetcher.fetchArticles(byQuery: field.text ?? "")
    }
    
    func fetcher(_ fetcher: NewsFetcher, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    
    func fetcher(_ fetcher: NewsFetcher, didReceiveResponse response: ArticlesResponse) {
        switch response.result {
        case .success(let response):
            articles = response.articles
            DispatchQueue.main.async { self.tableView?.reloadData() }
        case .error(let response):
            print(response.message)
        }
    }
}

