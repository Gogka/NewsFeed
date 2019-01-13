//
//  NetworkLayer.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class NetworkLayer {
    static let shared = NetworkLayer()
    private init() { }
    
    let session = URLSession(configuration: .default)
    
    func getImageTask(forURL url: URL, completion: @escaping (UIImage?) -> ()) -> URLSessionDataTask {
        return session.dataTask(with: url, completionHandler: { dataWrapped, _, errorWrapped in
            if let data = dataWrapped, let image = UIImage(data: data) {
                completion(image)
            } else {
                print(errorWrapped?.localizedDescription ?? "Incorrect data")
                completion(nil)
            }
        })
    }
}
