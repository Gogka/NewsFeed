//
//  NewsCollectionViewCell.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImageVIew: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    private let shadow: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTitle?.textColor = .white
        newsImageVIew?.contentMode = .scaleAspectFill
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        layer.insertSublayer(shadow, below: contentView.layer)
        backgroundColor = .clear
        clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        shadow.path = path
        shadow.shadowPath = path
    }

}
